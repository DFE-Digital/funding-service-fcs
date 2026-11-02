namespace FCT.Operations.DataStore.Tests.Integration
{
    using System;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using System.Text;
    using global::Operations.DataStore;
    using global::Operations.DataStore.Model;
    using global::Operations.DataStore.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class AuditMessageRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void AuditMessageRepository_ShouldAdd()
        {
            // arrange
            DeleteAll();
            Guid messageId = Guid.NewGuid();
            const string messageType = "some fully qual type";
            // act
            AuditMessageRepository.Add(new AuditMessage(
                new byte[0],
                messageType,
                DateTime.Now,
                messageId,
                "o_ep",
                "p_ep",
                "bk",
                new byte[0]), new OperationsDbContext().Database.Connection).Wait();

            // assert
            var message = GetRow(messageId);
            Assert.AreEqual("o_ep", message.OriginatingEndpoint, "The originatingEndpoint ia wrong");
            Assert.AreEqual("p_ep", message.ProcessingEndpoint, "The processingEndpoint ia wrong");
            Assert.AreEqual("bk", message.BusinessKey, "The businessKey ia wrong");
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void AuditMessageRepository_GetAndReHydrate()
        {
            using (var context = new OperationsDbContext())
            {
                var messages = context.AuditMessages.Where(a =>
                    a.MessageType == "SFA.FCT.CrossDomain.Integration.Messages.Commands.DocumentGenerationCommand"
                    && a.SentTime > new DateTime(2022, 3, 24, 15, 4, 0, DateTimeKind.Utc)
                    && a.SentTime < new DateTime(2022, 3, 24, 15, 10, 0, DateTimeKind.Utc)).ToList();

                var possibleMessages = messages.Select(m => m.GetMessageAsJson()).Where(c => c.Contains("SAD-1074")).ToList();

                //    a.MessageId.ToString() == "3FB2F556-572C-4173-B560-AC2A00F8B9A5");

                //var json = message.GetMessageAsJson();

                //var jsonProperties = message.GetPropertiesDictionary();

                int i = 0;
            }
        }

        private void DeleteAll()
        {
            using (var context = new OperationsDbContext())
            {
                context.AuditMessages.ToList().ForEach(m => { context.AuditMessages.Remove(m); });

                context.SaveChanges();
            }
        }

        private AuditMessage GetRow(Guid id)
        {
            using (var context = new OperationsDbContext())
            {
                return context.AuditMessages.Single(am => am.MessageId == id);
            }
        }

        private static string GetJson(string nameSpace, string resourceName)
        {
            using (Stream stream = Assembly.GetCallingAssembly().GetManifestResourceStream($"{nameSpace}.{resourceName}"))
            using (StreamReader streamReader = new StreamReader(stream))
            {
                return streamReader.ReadToEnd();
            }
        }
    }
}
