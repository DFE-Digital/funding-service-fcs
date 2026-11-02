namespace AllocationDeliveryDomain.Endpoint.Tests.Integration
{
    using Microsoft.ServiceBus;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using System.Configuration;
    using AllocationDeliveryDomain.Endpoint.Services;
    using Microsoft.ServiceBus.Messaging;
    using System;

    [TestClass]
    public class AzureServiceBusQueryServiceIntegrationTest
    {
        private NamespaceManager _namespaceManager;
        private const string TestQueue = "TestQueue";
        private const string TestTopic = "TestTopic";
        
        [TestInitialize]
        public void Initialize()
        {
            SetUpNameSpaceManagerForAzureServiceBus();
            CreateQueue();
            CreateTopic();
            CreateSubscriptionsForTopic();
        }

        [TestCleanup]
        public void Cleanup()
        {
            DeleteQueue();
            DeleteTopic();
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void SuccessWhenGettingNumberOfMessagesFromAQueue()
        {
            int numberOfExpectedMessages = 5;

            PopulateQueueWithMessages(numberOfExpectedMessages);
            
            IAzureServiceBusQueryService asbQueryService = new AzureServiceBusQueryService();
            long actualMessageCount = asbQueryService.GetQueueMessageCount(TestQueue);
            Assert.IsTrue(actualMessageCount == numberOfExpectedMessages,
                $"Expected number of messages {numberOfExpectedMessages} don't match with actual number of messages {actualMessageCount}");
        }

        
        [TestMethod, TestCategory("TechnicalExploration")]
        public void SuccessWhenMessagesFromSubscriptionToATopicAreRead()
        {
            int numberOfMessages = 5;
            int expectedMessageCount = 0;
            PopulateTopicWithMessages(numberOfMessages);

            ReadMessagesFromSubscription();

            IAzureServiceBusQueryService asbQueryService = new AzureServiceBusQueryService();
            long actualMessageCount = asbQueryService.GetTopicMessageCount(TestTopic);
            Assert.IsTrue(actualMessageCount == expectedMessageCount,
                $"Expected number of messages {expectedMessageCount} don't match with actual number of messages {actualMessageCount}");
        }

        private void ReadMessagesFromSubscription()
        {
            SubscriptionClient client =
                SubscriptionClient.CreateFromConnectionString
                        (GetConnectionString(), TestTopic, "AllMessages");

            BrokeredMessage message;
            while ((message = client.Receive())!=null)
            {
                message.Complete();
            } 
            client.Close();
        }

        private void SetUpNameSpaceManagerForAzureServiceBus()
        {
            _namespaceManager =
                NamespaceManager.CreateFromConnectionString(GetConnectionString());
        }

        private void CreateQueue()
        {
            if (!_namespaceManager.QueueExists(TestQueue))
            {
                _namespaceManager.CreateQueue(TestQueue);
            }
        }

        private void CreateTopic()
        {
            if (!_namespaceManager.TopicExists(TestTopic))
            {
                _namespaceManager.CreateTopic(TestTopic);
            }

        }

        private void CreateSubscriptionsForTopic()
        {
            if (!_namespaceManager.SubscriptionExists(TestTopic, "AllMessages"))
            {
                _namespaceManager.CreateSubscription(TestTopic, "AllMessages");
            }
        }

        private void DeleteQueue()
        {
            if (_namespaceManager.QueueExists(TestQueue))
            {
                _namespaceManager.DeleteQueue(TestQueue);
            }
        }

        private void DeleteTopic()
        {
            if (_namespaceManager.TopicExists(TestTopic))
            {
                _namespaceManager.DeleteTopic(TestTopic);
            }
        }

        private string GetConnectionString()
        {
            return ConfigurationManager.ConnectionStrings["NServiceBus/Transport"].ConnectionString;
        }

        private void PopulateQueueWithMessages(int numberOfExpectedMessages)
        {
            QueueClient client = QueueClient.CreateFromConnectionString(GetConnectionString(), TestQueue);

            for (int i = 0; i < numberOfExpectedMessages; i++)
            {
                // Create message, passing a string message for the body.
                BrokeredMessage message = new BrokeredMessage("Test message " + i);

                // Set additional custom app-specific property.
                message.Properties["MessageId"] = i;

                // Send message to the topic.
                client.Send(message);
            }
            client.Close();
        }

        private void PopulateTopicWithMessages(int numberofMessages)
        {
            TopicClient client = TopicClient.CreateFromConnectionString(GetConnectionString(), TestTopic);

            for (int i = 0; i < numberofMessages; i++)
            {
                // Create message, passing a string message for the body.
                BrokeredMessage message = new BrokeredMessage("Test message " + i);

                // Set additional custom app-specific property.
                message.Properties["MessageId"] = i;

                // Send message to the topic.
                client.Send(message);
            }
            client.Close();
        }
    }
    
}
