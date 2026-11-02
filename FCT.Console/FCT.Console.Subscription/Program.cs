namespace FCT.Console.Subscription
{
    using Microsoft.ServiceBus;
    using Microsoft.ServiceBus.Messaging;
    using SFA.FCS.Worker.Common;
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using System.Security.Cryptography;
    using System.Text;
    using Extensions;
    using SFA.FCT.CrossDomain.Integration.Events;

    public class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Starting FCT Console Subscription");
            if (ShouldCreateMissingSubscriptionsForFcsCore(args))
            {
                Console.WriteLine("Creating missing Subscriptions for FcsCore");
                CreateMissingSubscriptionsFromDotNetCoreServices();
            }
            else
            {
                Console.WriteLine("Creating missing Topics and Subscriptions");
                Console.WriteLine("-----------------------------------------");
                CreateTopicsAndSubscriptionsThatAreMissing();

                Console.WriteLine("Forwarding Dead Letters to Error Queue");
                Console.WriteLine("--------------------------------------");
                ForwardDeadLettersToErrorQueue();
            }
            
            Console.WriteLine("Finished FCT Console Subscription");
        }

        private static bool ShouldCreateMissingSubscriptionsForFcsCore(string[] args)
        {
            return args.Length == 1 && args[0] == "/FcsCore";
        }

        /// <summary>
        /// We need this method as .Net core NSB only supports message forwarding subscriptions
        /// </summary>
        private static void CreateMissingSubscriptionsFromDotNetCoreServices()
        {
            List<FcsSubscription> dotNetCoreRequiredSubscriptions = new List<FcsSubscription>
            {
                new FcsSubscription
                {
                    EventType = typeof(ContractApprovedEvent),
                    PublisherEndpoint = "contractmanagementdomain.contractapproved",
                    SubscriberEndpoint = "fundingallocation.contractapproved"
                },
                new FcsSubscription
                {
                    EventType = typeof(ContractWithdrawnEvent),
                    PublisherEndpoint = "contractmanagementdomain.initiatecontractwithdrawal",
                    SubscriberEndpoint = "fundingallocation.contractwithdrawn"
                },
                new FcsSubscription
                {
                    EventType = typeof(DraftContractDeletedEvent),
                    PublisherEndpoint = "ContractManagement.DeleteContract",
                    SubscriberEndpoint = "FundingAllocation.DraftContractDeleted"
                },
                new FcsSubscription
                {
                    EventType = typeof(FundingAllocationReleaseInProgressEvent),
                    PublisherEndpoint = "FundingAllocation.ReleaseGroup",
                    SubscriberEndpoint = "ContractRequestDomain.FundingAllocationRelease"
                },
                new FcsSubscription
                {
                    EventType = typeof(FundingAllocationReleaseGroupGroupReleasedEvent),
                    PublisherEndpoint = "FundingAllocation.ReleaseGroupSetToReleased",
                    SubscriberEndpoint = "ContractRequestDomain.FundingAllocationRelease"
                },
                new FcsSubscription
                {
                    EventType = typeof(BulkUploadCompleteEvent),
                    PublisherEndpoint = "ContractRequestDomain.BulkUpload",
                    SubscriberEndpoint = "FundingAllocation.BulkUpload"
                },
                new FcsSubscription
                {
                    EventType = typeof(BulkUploadInProgressEvent),
                    PublisherEndpoint = "ContractRequestDomain.BulkUpload",
                    SubscriberEndpoint = "FundingAllocation.BulkUpload"
                },
                new FcsSubscription
                {
                    EventType = typeof(ContractPublishedEvent),
                    PublisherEndpoint = "ContractManagementDomain.PublishContractToProvider",
                    SubscriberEndpoint = "FundingAllocation.ContractPublished"
                },
                new FcsSubscription
                {
                    EventType = typeof(MonthEndCompletedEvent),
                    PublisherEndpoint = "AllocationDeliveryDomain.MonthEndCheck",
                    SubscriberEndpoint = "Operations.IntegrityCheckers"
                }
            };

            NamespaceManager namespaceManager = GetAsbNamespaceManager();
            IReadOnlyCollection<AsbTopic> asbTopics = GetAsbTopics();
            IReadOnlyCollection<AsbSubscription> asbSubscriptions = asbTopics.SelectMany(t => t.Subscriptions).ToList();
            
            var missingDotNetCoreSubscriptions = dotNetCoreRequiredSubscriptions.Where(s =>
                !asbSubscriptions.Select(asbSub => asbSub.SubscriptionName).Contains(s.GetSubscriptionName())).ToList();

            UpdateExistingSubscriptionsThatDoNotHaveForwardToSet(namespaceManager, dotNetCoreRequiredSubscriptions,
                asbSubscriptions);

            missingDotNetCoreSubscriptions.ForEach(missingSub =>
            {
                CreateEndpointIfNotPresent(missingSub.SubscriberEndpoint, namespaceManager);
                CreateSubscriptionInAzureWithForwarding(missingSub, namespaceManager);
            });

            if (!missingDotNetCoreSubscriptions.Any())
            {
                Console.WriteLine($"All Fcs Core subscriptions are present");
            }
        }

        private static void UpdateExistingSubscriptionsThatDoNotHaveForwardToSet(NamespaceManager namespaceManager, List<FcsSubscription> dotNetCoreRequiredSubscriptions, IReadOnlyCollection<AsbSubscription> asbSubscriptions)
        {
            dotNetCoreRequiredSubscriptions.ForEach(requiredSub =>
            {
                var matchingAsbSubscription = asbSubscriptions.SingleOrDefault(asbSub =>
                    asbSub.SubscriptionName == requiredSub.GetSubscriptionName());
                if (matchingAsbSubscription != null &&
                    (matchingAsbSubscription.ForwardTo ?? "").ToLower().Contains(requiredSub.SubscriberEndpoint.ToLower()) == false)
                {
                    matchingAsbSubscription.ForwardTo = requiredSub.SubscriberEndpoint;
                    namespaceManager.UpdateSubscription(new SubscriptionDescription(matchingAsbSubscription.TopicPath, matchingAsbSubscription.SubscriptionName)
                    {
                        ForwardTo = requiredSub.SubscriberEndpoint,
                        UserMetadata = $"{requiredSub.SubscriberEndpoint} subscribed to {requiredSub.EventType.FullName}",
                    });
                    Console.WriteLine($"Updated Subscription topic: {matchingAsbSubscription.TopicPath}, name: {matchingAsbSubscription.SubscriptionName}, forward to: {requiredSub.SubscriberEndpoint}");
                }
            });
        }

        private static void CreateEndpointIfNotPresent(string queueName, NamespaceManager namespaceManager)
        {
            bool isQueuePresent = false;
            try
            {
                namespaceManager.GetQueue(queueName);
                isQueuePresent = true;
            }
            catch (MessagingEntityNotFoundException)
            {
            }

            if (!isQueuePresent)
            {
                CreateQueue(queueName, namespaceManager);
            }
        }

        private static void CreateQueue(string queueName, NamespaceManager namespaceManager)
        {
            long fiveGBInMegabytes = 5 * 1024;
            namespaceManager.CreateQueue(new QueueDescription(queueName)
            {
                LockDuration = TimeSpan.FromMinutes(5),
                MaxDeliveryCount = 2147483647,
                MaxSizeInMegabytes = fiveGBInMegabytes,
                ForwardDeadLetteredMessagesTo = "error"
            });
        }

        public static void CreateTopicsAndSubscriptionsThatAreMissing()
        {
            string workerRoleBinPath = Directory.GetCurrentDirectory();

            AppDomain.CurrentDomain.AssemblyResolve += (o, args) =>
            {
                string assemblyName = args.Name.Substring(0, args.Name.IndexOf(','));

                try
                {
                    Console.WriteLine($"Resolving Assembly - {assemblyName}");
                    return Assembly.LoadFile($@"{workerRoleBinPath}\{assemblyName}.dll");
                }
                catch (Exception e)
                {
                    Console.WriteLine($"AssemblyResolve Exception - {assemblyName} + {e.Message}");
                    return null;
                }
            };

            IReadOnlyCollection<FcsEndpoint> fcsEndpoints = GetFcsEndpoints(workerRoleBinPath);
            Console.WriteLine($"FCS endpoints - {fcsEndpoints.Count}");

            IReadOnlyCollection<FcsSubscription> fcsSubscriptions =
                fcsEndpoints.SelectMany(e => e.Subscriptions).ToList();

            List<string> fcsTopics = fcsSubscriptions.Select(s => $"{s.PublisherEndpoint.ToLower()}.events").Distinct().ToList();
            Console.WriteLine($"FCS topics - {fcsTopics.Count}");

            IReadOnlyCollection<AsbTopic> asbTopics = GetAsbTopics();
            Console.WriteLine($"ASB topics - {asbTopics.Count}");

            // are there any topics missing in Azure
            var missingTopics = fcsTopics.Where(fcsTopic =>
                !asbTopics.Select(t => t.Name).Contains(fcsTopic)).ToList();

            Console.WriteLine($"Missing topics - {missingTopics.Count}");

            NamespaceManager namespaceManager = GetAsbNamespaceManager();

            missingTopics.ForEach(topicName => CreateTopic(topicName, namespaceManager));

            IReadOnlyCollection<AsbSubscription> asbSubscriptions = asbTopics.SelectMany(t => t.Subscriptions).ToList();

            var fcsSubThatAreNotPresent = fcsSubscriptions.Where(fcsSubscription =>
                !asbSubscriptions.Select(asbSubscription => asbSubscription.SubscriptionName.ToLower())
                    .Contains(fcsSubscription.GetSubscriptionName().ToLower())).ToList();

            Console.WriteLine($"Missing subscriptions - {fcsSubThatAreNotPresent.Count}");

            fcsSubThatAreNotPresent.ForEach(fcsSub =>
            {
                CreateSubscriptionInAzure(fcsSub, namespaceManager);
            });
        }

        private static void ForwardDeadLettersToErrorQueue()
        {
            const string errorQueueName = "error";

            NamespaceManager namespaceManager = GetAsbNamespaceManager();
            var subscriptionsWithoutForwardDlq = namespaceManager.GetTopics().SelectMany(topic =>
            {
                return namespaceManager.GetSubscriptions(topic.Path)
                    .Where(sub => sub.ForwardDeadLetteredMessagesTo.IsNullOrEmpty())
                    .ToList();
            }).ToList();

            Console.WriteLine($"ForwardDeadLettersToErrorQueue, number of Subscriptions to set - {subscriptionsWithoutForwardDlq.Count}");

            subscriptionsWithoutForwardDlq.ForEach(sub =>
            {
                Console.WriteLine($"updating subscription - {sub.Name}");
                sub.ForwardDeadLetteredMessagesTo = errorQueueName;
                namespaceManager.UpdateSubscription(sub);
            });

            var queuesWithoutForwardDlq = namespaceManager.GetQueues()
            .Where(q => q.Path != "error" && q.ForwardDeadLetteredMessagesTo.IsNullOrEmpty())
            .ToList();

            Console.WriteLine($"ForwardDeadLettersToErrorQueue, number of Queues to set - {queuesWithoutForwardDlq.Count}");

            queuesWithoutForwardDlq.ForEach(queue =>
            {
                Console.WriteLine($"updating queue - {queue.Path}");
                queue.ForwardDeadLetteredMessagesTo = errorQueueName;
                namespaceManager.UpdateQueue(queue);
            });
        }

        private static void CreateTopic(string topicName, NamespaceManager namespaceManager)
        {
            namespaceManager.CreateTopic(topicName);
        }

        private static void CreateSubscriptionInAzure(FcsSubscription fcsSubscription, NamespaceManager namespaceManager)
        {
            SubscriptionDescription subscriptionDescription =
                new SubscriptionDescription($"{fcsSubscription.PublisherEndpoint}.events", fcsSubscription.GetSubscriptionName())
                {
                    UserMetadata = $"{fcsSubscription.SubscriberEndpoint} subscribed to {fcsSubscription.EventType.FullName}",

                };
            Filter filter = new SqlFilter($"[NServiceBus.EnclosedMessageTypes] LIKE '%{fcsSubscription.EventType.FullName}%'");
            try
            {
                Console.WriteLine($"Creating Subscription - {fcsSubscription}");
                namespaceManager.CreateSubscription(subscriptionDescription, filter);
            }
            catch (Exception e)
            {
                Console.WriteLine($"Error creating - {fcsSubscription}, reason: {e.Message}");
            }
        }

        private static void CreateSubscriptionInAzureWithForwarding(FcsSubscription fcsSubscription, NamespaceManager namespaceManager)
        {
            SubscriptionDescription subscriptionDescription =
                new SubscriptionDescription($"{fcsSubscription.PublisherEndpoint}.events", fcsSubscription.GetSubscriptionName())
                {
                    UserMetadata = $"{fcsSubscription.SubscriberEndpoint} subscribed to {fcsSubscription.EventType.FullName}",
                    ForwardTo = fcsSubscription.SubscriberEndpoint
                };
            Filter filter = new SqlFilter($"[NServiceBus.EnclosedMessageTypes] LIKE '%{fcsSubscription.EventType.FullName}%'");
            try
            {
                Console.WriteLine($"Creating Subscription - {fcsSubscription}");
                namespaceManager.CreateSubscription(subscriptionDescription, filter);
            }
            catch (Exception e)
            {
                Console.WriteLine($"Error creating - {fcsSubscription}, reason: {e.Message}");
            }
        }

        private static IReadOnlyCollection<FcsEndpoint> GetFcsEndpoints(string directoryPath)
        {
            Console.WriteLine($"Scanning for FCS endpoints in - {directoryPath}");
            try
            {
                return GetScannedAssemblyTypes(directoryPath)
                    .Where(t => !t.IsAbstract && t.GetInterfaces().Contains(typeof(IEndpointConfig)))
                    .Select(t => (IEndpointConfig) Activator.CreateInstance(t))
                    .Select(ec => new FcsEndpoint(ec.EndpointName, ec.Subscriptions.Select(s => new FcsSubscription
                    {
                        PublisherEndpoint = s.PublisherName,
                        SubscriberEndpoint = ec.EndpointName,
                        EventType = s.EventType
                    }).ToList())).ToList();
            }
            catch (ReflectionTypeLoadException e)
            {
                Console.WriteLine(e.LoaderExceptions.First().Message);
                throw;
            }
        }

        private static IReadOnlyCollection<Type> GetScannedAssemblyTypes(string directoryPath)
        {
            string[] excludedWordsInAssemblies = {
                "Microsoft",
                "Castle",
                "Aspose",
                "Oracle",
                "NServiceBus",
                "System",
                "Azure",
                "CrossDomain.Integration.Common",
                "AutoMapper",
                "PaymentManagementDomain.PaymentSchedule.Xrm.Integration"
            };

            List<string> assemblyNames =
                Directory.GetFiles(directoryPath, "*.dll")
                    .Where(f => !excludedWordsInAssemblies.Any(f.Contains))
                    .ToList();

            Console.WriteLine("Assembly Names to scan -" + string.Join(",", assemblyNames));
            return assemblyNames
                .SelectMany(p => Assembly.LoadFile(Path.Combine(directoryPath, p)).GetTypes())
                .ToList();
        }

        private static IReadOnlyCollection<AsbTopic> GetAsbTopics()
        {
            NamespaceManager namespaceManager = GetAsbNamespaceManager();

            return
                namespaceManager.GetTopics()
                    .Select(t => new AsbTopic(t.Path, namespaceManager.GetSubscriptions(t.Path).Select(s =>
                        new AsbSubscription
                        {
                            TopicPath = s.TopicPath,
                            SubscriptionName = s.Name,
                            UserMetadata = s.UserMetadata,
                            ForwardTo = s.ForwardTo
                        }).ToList()))
                    .ToList();
        }

        private static NamespaceManager GetAsbNamespaceManager()
        {
            return NamespaceManager.CreateFromConnectionString(ConfigurationManager.ConnectionStrings["NServiceBus/Transport"].ConnectionString);
        }

        public static string GetMd5Hash(string input)
        {
            //use MD5 hash to get a 16-byte hash of the string
            using (var provider = new MD5CryptoServiceProvider())
            {
                var inputBytes = Encoding.Default.GetBytes(input);
                var hashBytes = provider.ComputeHash(inputBytes);

                return new Guid(hashBytes).ToString();
            }
        }

        private class FcsSubscription
        {
            public string PublisherEndpoint { get; set; }

            public string SubscriberEndpoint { get; set; }

            public Type EventType { get; set; }

            public string GetSubscriptionName()
            {
                string simpleSubscriptionName = $"{SubscriberEndpoint}.{GetEventName()}";

                if (simpleSubscriptionName.Length > 50)
                {
                    return Program.GetMd5Hash(simpleSubscriptionName);
                }

                return simpleSubscriptionName;
            }

            private string GetEventName()
            {
                var eventFullNameParts = EventType.FullName.Split('.');

                return eventFullNameParts[eventFullNameParts.Length - 1];
            }

            public override string ToString()
            {
                return $"PublisherEndpoint: {PublisherEndpoint}, SubscriptionName: {GetSubscriptionName()}, SubscriberEndpoint: {SubscriberEndpoint}, EventType: {EventType.FullName}";
            }
        }

        private class FcsEndpoint
        {
            public FcsEndpoint(string endpointName, IReadOnlyCollection<FcsSubscription> subscriptions)
            {
                EndpointName = endpointName;
                Subscriptions = subscriptions;
            }

            public string EndpointName { get; }

            public IReadOnlyCollection<FcsSubscription> Subscriptions { get; }
        }

        private class AsbTopic
        {
            public AsbTopic(string name, IReadOnlyCollection<AsbSubscription> subscriptions)
            {
                Name = name;
                Subscriptions = subscriptions;
            }

            public string Name { get; }

            public IReadOnlyCollection<AsbSubscription> Subscriptions { get; }
        }

        private class AsbSubscription
        {
            public string TopicPath { get; set; }

            public string UserMetadata { get; set; }

            public string SubscriptionName { get; set; }
            public string ForwardTo { get; set; }

            public string GetSubscriber()
            {
                return UserMetadata.Split(' ')[0];
            }

            public string GetEventName()
            {
                var eventFullNameParts = GetEventFullName().Split('.');

                return eventFullNameParts[eventFullNameParts.Length - 1];
            }

            private string GetEventFullName()
            {
                var metaDataParts = UserMetadata.Split(' ');

                return metaDataParts[metaDataParts.Length - 1];
            }
        }
    }
}
