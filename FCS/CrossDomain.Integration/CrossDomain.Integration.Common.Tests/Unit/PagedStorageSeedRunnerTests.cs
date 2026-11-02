namespace CrossDomain.Integration.Common.Tests.Unit
{
    using System;
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage.Exceptions;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class PagedStorageSeedRunnerTests
    {
        private Mock<IPagedStorageSeed<TestFixture>> _seedMock;
        private Mock<ILogger> _loggerMock;
        private Mock<IPagedStorageRepository<TestFixture>> _repositoryMock;
        private IPagedStorageSeedRunner<TestFixture> _seedRunner;

        [TestInitialize]
        public void TestInitialize()
        {
            _seedMock = new Mock<IPagedStorageSeed<TestFixture>>();
            _loggerMock = new Mock<ILogger>();
            _seedMock
                .Setup(m => m.GetDataEnumerable())
                .Returns(new List<TestFixture>
                {
                    new TestFixture { Id = 1 },
                    new TestFixture { Id = 2 },
                    new TestFixture { Id = 3 }
                });
            _repositoryMock = new Mock<IPagedStorageRepository<TestFixture>>();
            _seedRunner = new PagedStorageSeedRunner<TestFixture>(_loggerMock.Object, _repositoryMock.Object);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PagedStorageSeedRunner_Calling_Run()
        {
            _seedRunner.Execute(_seedMock.Object);

            _seedMock.Verify(m => m.GetDataEnumerable(), Times.Once, "Seed GetData was not called");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PagedStorageSeedRunner_Calling_Run_TerminatesWithoutProcessingIfRepositoryNotEmpty()
        {
            _repositoryMock
                .Setup(x => x.Any())
                .Returns(true);

            _seedRunner.Execute(_seedMock.Object);

            _seedMock.Verify(m => m.GetDataEnumerable(), Times.Never, "Seed GetData was called");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PagedStorageSeedRunner_Calling_Run_ShouldHandleDuplicateKeyStorageExceptionAndContinueProcessing()
        {
            // throw exception when storing the 2nd of the 3 entities the seed mock will provide
            _repositoryMock
                .Setup(x => x.Add(It.Is<TestFixture>(f => f.Id == 2)))
                .Throws(new DuplicateKeyStorageException(new Exception()));

            _seedRunner.Execute(_seedMock.Object);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PagedStorageSeedRunner_Calling_Run_ShouldHandleArgumentExceptionAndContinueProcessing()
        {
            // throw exception when storing the 2nd of the 3 entities the seed mock will provide
            _repositoryMock
                .Setup(x => x.Add(It.Is<TestFixture>(f => f.Id == 2)))
                .Throws(new ArgumentException());

            _seedRunner.Execute(_seedMock.Object);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PagedStorageSeedRunner_Calling_Run_ShouldHandleGeneralExceptionAndContinueProcessing()
        {
            // throw exception when storing the 2nd of the 3 entities the seed mock will provide
            _repositoryMock
                .Setup(x => x.Add(It.Is<TestFixture>(f => f.Id == 2)))
                .Throws(new Exception());

            _seedRunner.Execute(_seedMock.Object);
        }

        public class TestFixture
        {
            public int Id { get; set; }
        }
    }
}
