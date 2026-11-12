namespace Datafix.Tests
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using System.Security.Cryptography;
    using System.Text;
    using Microsoft.ServiceBus;
    using Microsoft.ServiceBus.Messaging;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCS.Worker.Common;

    [TestClass]
    public class NServiceBus7SubscriptionTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ShouldFindAllNServiceBus7SubscriptionsArePresent()
        {
            string workerRoleBinPath = Directory.GetCurrentDirectory().Replace("Datafix.Tests", "WorkerRole");

            AppDomain.CurrentDomain.AssemblyResolve += (o, args) =>
            {
                string assemblyName = args.Name.Substring(0, args.Name.IndexOf(','));

                try
                {
                    return Assembly.LoadFile($@"{workerRoleBinPath}\{assemblyName}.dll");
                }
                catch (Exception)
                {
                    return null;
                }
            };

            IReadOnlyCollection<FcsSubscription> fcsSubscriptions = GetFcsSubscriptions(workerRoleBinPath);
            Assert.AreNotEqual(0, fcsSubscriptions.Count, "No FCS subscriptions found");

            IReadOnlyCollection<AsbSubscription> asbSubscriptions = GetAsbSubscriptions();

            IReadOnlyCollection<FcsSubscription> unmatchedSubscriptions =
                fcsSubscriptions
                    .Where(fcs => !asbSubscriptions.Any(asb => IsMatchingSubscription(fcs, asb)))
                    .ToList();

            Assert.IsFalse(unmatchedSubscriptions.Any(),
                $"The following {unmatchedSubscriptions.Count} subscriptions are missing from an expected {fcsSubscriptions.Count}: {Environment.NewLine}{string.Join($",{Environment.NewLine}", unmatchedSubscriptions.Select(s => $"[{s}]"))}");

            IReadOnlyCollection<FcsSubscription> duplicatedSubscriptions =
                fcsSubscriptions
                    .Where(fcs => HasDuplicateSubscriptions(fcs, asbSubscriptions))
                    .ToList();

            Assert.IsFalse(duplicatedSubscriptions.Any(),
                $"The following {duplicatedSubscriptions.Count} subscriptions are duplicated: {Environment.NewLine}{string.Join($",{Environment.NewLine}", duplicatedSubscriptions.Select(s => $"[{s}]"))}");

            var fcsSubThatAreNotPresent = fcsSubscriptions.Where(fcsSubscription =>
                !asbSubscriptions.Select(asbSubscription => asbSubscription.SubscriptionName)
                    .Contains(fcsSubscription.GetSubscriptionName())).ToList();
            Assert.IsTrue(!fcsSubThatAreNotPresent.Any(), $"We have subscription name(s) missing from this endpoint : {fcsSubThatAreNotPresent.FirstOrDefault()?.PublisherEndpoint}");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ShouldCreateTopicesAndSubscriptionsThatAreMissing()
        {
            string workerRoleBinPath = Directory.GetCurrentDirectory().Replace("Datafix.Tests", "WorkerRole");

            AppDomain.CurrentDomain.AssemblyResolve += (o, args) =>
            {
                string assemblyName = args.Name.Substring(0, args.Name.IndexOf(','));

                try
                {
                    return Assembly.LoadFile($@"{workerRoleBinPath}\{assemblyName}.dll");
                }
                catch (Exception)
                {
                    return null;
                }
            };

            IReadOnlyCollection<FcsEndpoint> fcsEndpoints = GetFcsEndoints(workerRoleBinPath);

            IReadOnlyCollection<FcsSubscription> fcsSubscriptions =
                fcsEndpoints.SelectMany(e => e.Subscriptions).ToList();

            List<string> fcsTopics = fcsSubscriptions.Select(s => $"{s.PublisherEndpoint.ToLower()}.events").Distinct().ToList();

            Assert.AreNotEqual(0, fcsSubscriptions.Count, "No FCS subscriptions found");

            IReadOnlyCollection<AsbTopic> asbTopics = GetAsbTopics();

            // are there any topics missing in Azure
            var missingTopics = fcsTopics.Where(fcsTopic => 
                !asbTopics.Select(t => t.Name).Contains(fcsTopic)).ToList();

            Console.WriteLine($"Missing topics - {missingTopics.Count}");

            NamespaceManager namespaceManager = GetAsbNamespaceManager();

            missingTopics.ForEach(topicName => CreateTopic(topicName, namespaceManager));

            IReadOnlyCollection<AsbSubscription> asbSubscriptions = asbTopics.SelectMany(t => t.Subscriptions).ToList();

            var fcsSubThatAreNotPresent = fcsSubscriptions.Where(fcsSubscription =>
                !asbSubscriptions.Select(asbSubscription => asbSubscription.SubscriptionName.ToLower())
                    .Contains(fcsSubscription.GetSubscriptionName())).ToList();

            Console.WriteLine($"Missing subscriptions - {fcsSubThatAreNotPresent.Count}");

            fcsSubThatAreNotPresent.ForEach(fcsSub =>
            {
                CreateSubscriptionInAzure(fcsSub, namespaceManager);
            });
        }

        private static void CreateTopic(string topicName, NamespaceManager namespaceManager)
        {
            namespaceManager.CreateTopic(topicName);
        }

        private void CreateSubscriptionInAzure(FcsSubscription fcsSubscription, NamespaceManager namespaceManager)
        {
            SubscriptionDescription subscriptionDescription =
                new SubscriptionDescription($"{fcsSubscription.PublisherEndpoint}.events", fcsSubscription.GetSubscriptionName())
                {
                    UserMetadata = $"{fcsSubscription.SubscriberEndpoint} subscribed to {fcsSubscription.EventType.FullName}",
                    
                };
            Filter filter = new SqlFilter($"[NServiceBus.EnclosedMessageTypes] LIKE '%{fcsSubscription.EventType.FullName}%'");

            namespaceManager.CreateSubscription(subscriptionDescription, filter);
        }

        private static bool HasDuplicateSubscriptions(FcsSubscription fcsSubscription, IReadOnlyCollection<AsbSubscription> asbSubscriptions)
        {
            return asbSubscriptions.Count(asb => IsMatchingSubscription(fcsSubscription, asb)) > 1;
        }

        private static bool IsMatchingSubscription(FcsSubscription fcsSubscription, AsbSubscription asbSubscription)
        {
            return
                    asbSubscription.TopicPath == $"{fcsSubscription.PublisherEndpoint.ToLower()}.events" &&
                    (
                        IsMatchingUserMetadata(fcsSubscription.SubscriberEndpoint, fcsSubscription.EventType.FullName, asbSubscription)
                        || fcsSubscription.EventType.GetInterfaces().Any(i =>
                            IsMatchingUserMetadata(fcsSubscription.SubscriberEndpoint, i.FullName, asbSubscription))
                    );
        }

        private static bool IsMatchingUserMetadata(string fcsSubscriberEndpointName, string fcsEventTypeFullName, AsbSubscription asbSubscription)
        {
            return asbSubscription.UserMetadata == $"{fcsSubscriberEndpointName} subscribed to {fcsEventTypeFullName}";
        }

        private static IReadOnlyCollection<FcsSubscription> GetFcsSubscriptions(string directoryPath)
        {
            return GetScannedAssemblyTypes(directoryPath)
                .Where(t => !t.IsAbstract && t.GetInterfaces().Contains(typeof(IEndpointConfig)))
                .Select(t => (IEndpointConfig)Activator.CreateInstance(t))
                .SelectMany(ec => ec.Subscriptions.Select(s => new FcsSubscription
                {
                    PublisherEndpoint = s.PublisherName,
                    SubscriberEndpoint = ec.EndpointName,
                    EventType = s.EventType
                }))
                .ToList();
        }

        private static IReadOnlyCollection<FcsEndpoint> GetFcsEndoints(string directoryPath)
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
                "Common",
                "AutoMapper",
                "PaymentManagementDomain.PaymentSchedule.Xrm.Integration"
            };

            List<string> assemblyNames =
                Directory.GetFiles(directoryPath, "*.dll")
                    .Where(f => !excludedWordsInAssemblies.Any(f.Contains))
                    .ToList();

            return assemblyNames
                .SelectMany(p => Assembly.LoadFile(Path.Combine(directoryPath, p)).GetTypes())
                .ToList();
        }

        private static IReadOnlyCollection<AsbSubscription> GetAsbSubscriptions()
        {
            NamespaceManager namespaceManager = GetAsbNamespaceManager();

            return
                namespaceManager.GetTopics()
                .SelectMany(t => namespaceManager.GetSubscriptions(t.Path))
                .Select(s => new AsbSubscription
                {
                    TopicPath = s.TopicPath,
                    SubscriptionName = s.Name,
                    UserMetadata = s.UserMetadata
                })
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
                            UserMetadata = s.UserMetadata
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
                    return GetMd5Hash(simpleSubscriptionName);
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
                return $"PublisherEndpoint: {PublisherEndpoint}, SubscriberEndpoint: {SubscriberEndpoint}, EventType: {EventType.FullName}";
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
