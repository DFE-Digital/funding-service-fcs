
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
    using System.Threading.Tasks;
    using Azure.Messaging.ServiceBus.Administration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCS.Worker.Common;

    [TestClass]
    public class NServiceBus7SubscriptionTests
    {
        [TestMethod]
        public async Task ShouldFindAllNServiceBus7SubscriptionsArePresent()
        {
            string workerRoleBinPath = Directory.GetCurrentDirectory().Replace("Datafix.Tests", "WorkerRole");

            ResolveAssemblies(workerRoleBinPath);

            var fcsSubscriptions = GetFcsSubscriptions(workerRoleBinPath);
            Assert.AreNotEqual(0, fcsSubscriptions.Count, "No FCS subscriptions found");

            var asbSubscriptions = await GetAsbSubscriptions();

            var unmatchedSubscriptions =
                fcsSubscriptions
                    .Where(fcs => !asbSubscriptions.Any(asb => IsMatchingSubscription(fcs, asb)))
                    .ToList();

            Assert.IsFalse(unmatchedSubscriptions.Any(),
                $"Missing subscriptions: {Environment.NewLine}{string.Join(Environment.NewLine, unmatchedSubscriptions)}");

            var duplicatedSubscriptions =
                fcsSubscriptions
                    .Where(fcs => HasDuplicateSubscriptions(fcs, asbSubscriptions))
                    .ToList();

            Assert.IsFalse(duplicatedSubscriptions.Any(),
                $"Duplicated subscriptions: {Environment.NewLine}{string.Join(Environment.NewLine, duplicatedSubscriptions)}");
        }

        [TestMethod]
        public async Task ShouldCreateTopicesAndSubscriptionsThatAreMissing()
        {
            string workerRoleBinPath = Directory.GetCurrentDirectory().Replace("Datafix.Tests", "WorkerRole");

            ResolveAssemblies(workerRoleBinPath);

            var fcsEndpoints = GetFcsEndoints(workerRoleBinPath);

            var fcsSubscriptions = fcsEndpoints.SelectMany(e => e.Subscriptions).ToList();
            var fcsTopics = fcsSubscriptions.Select(s => $"{s.PublisherEndpoint.ToLower()}.events").Distinct().ToList();

            var client = GetAdminClient();

            var asbTopics = await GetAsbTopics();

            var missingTopics = fcsTopics
                .Where(fcsTopic => !asbTopics.Select(t => t.Name).Contains(fcsTopic))
                .ToList();

            foreach (var topic in missingTopics)
            {
                if (!await client.TopicExistsAsync(topic))
                {
                    await client.CreateTopicAsync(topic);
                }
            }

            var asbSubscriptions = await GetAsbSubscriptions();

            var missingSubscriptions = fcsSubscriptions
                .Where(fcs => !asbSubscriptions.Select(a => a.SubscriptionName.ToLower())
                .Contains(fcs.GetSubscriptionName()))
                .ToList();

            foreach (var fcsSub in missingSubscriptions)
            {
                await CreateSubscriptionInAzure(fcsSub, client);
            }
        }

        // ✅ Azure Service Bus (NEW SDK)

        private static ServiceBusAdministrationClient GetAdminClient()
        {
            return new ServiceBusAdministrationClient(
                ConfigurationManager.ConnectionStrings["NServiceBus/Transport"].ConnectionString);
        }

        private static async Task<IReadOnlyCollection<AsbSubscription>> GetAsbSubscriptions()
        {
            var topics = await GetAsbTopics();
            return topics.SelectMany(t => t.Subscriptions).ToList();
        }

        private static async Task<IReadOnlyCollection<AsbTopic>> GetAsbTopics()
        {
            var client = GetAdminClient();

            var topics = new List<AsbTopic>();

            await foreach (var topic in client.GetTopicsAsync())
            {
                var subs = new List<AsbSubscription>();

                await foreach (var sub in client.GetSubscriptionsAsync(topic.Name))
                {
                    subs.Add(new AsbSubscription
                    {
                        TopicPath = topic.Name,
                        SubscriptionName = sub.SubscriptionName,
                        UserMetadata = sub.UserMetadata
                    });
                }

                topics.Add(new AsbTopic(topic.Name, subs));
            }

            return topics;
        }

        private static async Task CreateSubscriptionInAzure(
            FcsSubscription fcsSubscription,
            ServiceBusAdministrationClient client)
        {
            var topicName = $"{fcsSubscription.PublisherEndpoint}.events";
            var subscriptionName = fcsSubscription.GetSubscriptionName();

            if (await client.SubscriptionExistsAsync(topicName, subscriptionName))
                return;

            var options = new CreateSubscriptionOptions(topicName, subscriptionName)
            {
                UserMetadata = $"{fcsSubscription.SubscriberEndpoint} subscribed to {fcsSubscription.EventType.FullName}"
            };

            var rule = new CreateRuleOptions
            {
                Name = "$Default",
                Filter = new SqlRuleFilter(
                    $"NServiceBus.EnclosedMessageTypes LIKE '%{fcsSubscription.EventType.FullName}%'")
            };

            await client.CreateSubscriptionAsync(options, rule);
        }

        // ✅ Existing logic (UNCHANGED)

        private static bool HasDuplicateSubscriptions(FcsSubscription fcs, IReadOnlyCollection<AsbSubscription> asbSubs)
        {
            return asbSubs.Count(a => IsMatchingSubscription(fcs, a)) > 1;
        }

        private static bool IsMatchingSubscription(FcsSubscription fcs, AsbSubscription asb)
        {
            return asb.TopicPath == $"{fcs.PublisherEndpoint.ToLower()}.events" &&
                   asb.UserMetadata.Contains(fcs.EventType.FullName);
        }

        // ✅ Assembly scanning

        private static void ResolveAssemblies(string path)
        {
            AppDomain.CurrentDomain.AssemblyResolve += (o, args) =>
            {
                string name = args.Name.Split(',')[0];
                string file = Path.Combine(path, $"{name}.dll");

                return File.Exists(file) ? Assembly.LoadFile(file) : null;
            };
        }

        private static IReadOnlyCollection<FcsSubscription> GetFcsSubscriptions(string path)
        {
            return GetScannedAssemblyTypes(path)
                .Where(t => !t.IsAbstract && typeof(IEndpointConfig).IsAssignableFrom(t))
                .Select(t => (IEndpointConfig)Activator.CreateInstance(t))
                .SelectMany(ec => ec.Subscriptions.Select(s => new FcsSubscription
                {
                    PublisherEndpoint = s.PublisherName,
                    SubscriberEndpoint = ec.EndpointName,
                    EventType = s.EventType
                }))
                .ToList();
        }

        private static IReadOnlyCollection<FcsEndpoint> GetFcsEndoints(string path)
        {
            return GetFcsSubscriptions(path)
                .GroupBy(s => s.SubscriberEndpoint)
                .Select(g => new FcsEndpoint(g.Key, g.ToList()))
                .ToList();
        }

        private static IReadOnlyCollection<Type> GetScannedAssemblyTypes(string path)
        {
            return Directory.GetFiles(path, "*.dll")
                .SelectMany(f => Assembly.LoadFile(f).GetTypes())
                .ToList();
        }

        // ✅ Helpers

        public static string GetMd5Hash(string input)
        {
            using var provider = MD5.Create();
            var bytes = Encoding.UTF8.GetBytes(input);
            return new Guid(provider.ComputeHash(bytes)).ToString();
        }

        // ✅ Models (unchanged)

        private class FcsSubscription
        {
            public string PublisherEndpoint { get; set; }
            public string SubscriberEndpoint { get; set; }
            public Type EventType { get; set; }

            public string GetSubscriptionName()
            {
                var name = $"{SubscriberEndpoint}.{EventType.Name}";
                return name.Length > 50 ? GetMd5Hash(name) : name;
            }
        }

        private class FcsEndpoint
        {
            public FcsEndpoint(string name, IReadOnlyCollection<FcsSubscription> subs)
            {
                EndpointName = name;
                Subscriptions = subs;
            }

            public string EndpointName { get; }
            public IReadOnlyCollection<FcsSubscription> Subscriptions { get; }
        }

        private class AsbTopic
        {
            public AsbTopic(string name, IReadOnlyCollection<AsbSubscription> subs)
            {
                Name = name;
                Subscriptions = subs;
            }

            public string Name { get; }
            public IReadOnlyCollection<AsbSubscription> Subscriptions { get; }
        }

        private class AsbSubscription
        {
            public string TopicPath { get; set; }
            public string SubscriptionName { get; set; }
            public string UserMetadata { get; set; }
        }
    }
}
