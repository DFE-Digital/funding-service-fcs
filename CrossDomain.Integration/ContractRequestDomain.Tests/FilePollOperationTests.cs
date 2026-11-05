namespace ContractRequestDomain.Tests
{
    using System;
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Interfaces;
    using SFA.FCT.ContractRequestDomain.Integration.FileWatcher;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;

    [TestClass]
    public class FilePollOperationTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void Poll_WhenNoFilesAreAvailable_DoesNotPublishMessages()
        {
            var fileAccess = new Mock<IBulkUploadFileAccess>();
            var bus = new RecordingBus();
            fileAccess.Setup(x => x.GetNewFiles()).Returns(new List<string>());
            var operation = new FilePollOperation(Mock.Of<ILogger>(), fileAccess.Object, bus);

            operation.Poll();

            Assert.AreEqual(0, bus.Events.Count);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Poll_WhenFilesAreAvailable_PublishesOneEventPerFileWithUniqueBatchIds()
        {
            var fileAccess = new Mock<IBulkUploadFileAccess>();
            var bus = new RecordingBus();
            fileAccess.Setup(x => x.GetNewFiles()).Returns(new List<string> { "first.xlsx", "second.xlsx" });
            var operation = new FilePollOperation(Mock.Of<ILogger>(), fileAccess.Object, bus);

            operation.Poll();

            Assert.AreEqual(2, bus.Events.Count);
            Assert.AreEqual("first.xlsx", bus.Events[0].UploadedFilename);
            Assert.AreEqual("second.xlsx", bus.Events[1].UploadedFilename);
            Assert.AreNotEqual(bus.Events[0].BatchId, bus.Events[1].BatchId);
            Assert.IsTrue(Guid.TryParse(bus.Events[0].BatchId, out _));
            Assert.IsTrue(Guid.TryParse(bus.Events[1].BatchId, out _));
        }

        private sealed class RecordingBus : IFcsBus
        {
            public List<INewExcelUploadFileEvent> Events { get; } = new List<INewExcelUploadFileEvent>();

            public Task Publish<T>(Action<T> messageConstructor)
            {
                var message = new NewExcelUploadFileEvent();
                messageConstructor((T)(object)message);
                Events.Add(message);
                return Task.FromResult(0);
            }
        }

        private sealed class NewExcelUploadFileEvent : INewExcelUploadFileEvent
        {
            public string UploadedFilename { get; set; }
            public string BatchId { get; set; }
        }
    }
}
