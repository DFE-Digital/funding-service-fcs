namespace SFA.FCT.Contracts.AcceptanceTests.Steps
{
    using System.Collections.Generic;
    using Infrastructure.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TechTalk.SpecFlow;
    using Utilities;
    using NUnit.Framework.Legacy;

    [Binding]
    public class MessageCheckingSteps
    {
        [When(@"there are no messages on the '(.*)' queue")]
        public void ThenThereAreNoMessageOnTheQueue(string queueName)
        {
            CheckResultPoller checkResultPoller = new CheckResultPoller(checkResult: () => AzureServiceBusService.GetQueueMessageCount(queueName) == 0,
                maxNumChecks: 10,
                waitIntervalSeconds: 6);

            bool isTopicEmpty = checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();

            ClassicAssert.IsTrue(isTopicEmpty, $"The Queue - {queueName} is not empty");
        }

        [When(@"there are no messages left in the system")]
        [Given(@"there are no messages left in the system")]
        public void ThenThereAreNoMessagesLeftInTheSystem()
        {
            CheckResultPoller checkResultPoller = new CheckResultPoller(checkResult: () => AzureServiceBusService.GetTotalTopicMessageCount(topicsToIgnore: new List<string>{ "orgservice.main.events" }) == 0,
                maxNumChecks: 10,
                waitIntervalSeconds: 6);

            bool isTheSystemEmptyOfMessages = checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();

            ClassicAssert.IsTrue(isTheSystemEmptyOfMessages, $"The system still has messages on the topics");
        }
    }
}
