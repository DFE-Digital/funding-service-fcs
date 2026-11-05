namespace FCS.Worker.Common.Tests
{
    using System;
    using System.Diagnostics;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Query;
    using Moq;
    using SFA.FCS.Worker.Common.Crm;

    [TestClass]
    public class RetryOnErrorOrganizationServiceTests
    {
        private Mock<IOrganizationService> _inner;
        private RetryOnErrorOrganizationService _service;

        [TestInitialize]
        public void Init()
        {
            _inner = new Mock<IOrganizationService>();
            _service = new RetryOnErrorOrganizationService(_inner.Object);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Create_ReturnsIdFromInnerService()
        {
            var id = Guid.NewGuid();
            _inner.Setup(s => s.Create(It.IsAny<Entity>())).Returns(id);

            Assert.AreEqual(id, _service.Create(new Entity("account")));
            _inner.Verify(s => s.Create(It.IsAny<Entity>()), Times.Once());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Create_RetriesAfterTransientFailure()
        {
            var id = Guid.NewGuid();
            _inner.SetupSequence(s => s.Create(It.IsAny<Entity>()))
                .Throws(new InvalidOperationException("transient"))
                .Returns(id);

            Assert.AreEqual(id, _service.Create(new Entity("account")));
            _inner.Verify(s => s.Create(It.IsAny<Entity>()), Times.Exactly(2));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Update_RetriesAfterTransientFailure()
        {
            int calls = 0;
            _inner.Setup(s => s.Update(It.IsAny<Entity>()))
                .Callback(() =>
                {
                    if (++calls == 1)
                    {
                        throw new InvalidOperationException("transient");
                    }
                });

            _service.Update(new Entity("account"));

            _inner.Verify(s => s.Update(It.IsAny<Entity>()), Times.Exactly(2));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Execute_RetriesAfterTransientFailure()
        {
            var response = new OrganizationResponse();
            _inner.SetupSequence(s => s.Execute(It.IsAny<OrganizationRequest>()))
                .Throws(new InvalidOperationException("transient"))
                .Returns(response);

            Assert.AreSame(response, _service.Execute(new OrganizationRequest()));
            _inner.Verify(s => s.Execute(It.IsAny<OrganizationRequest>()), Times.Exactly(2));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Delete_SwallowsDoesNotExistWithoutRetrying()
        {
            _inner.Setup(s => s.Delete(It.IsAny<string>(), It.IsAny<Guid>()))
                .Throws(new InvalidOperationException("Entity Does Not Exist"));

            var watch = Stopwatch.StartNew();
            _service.Delete("account", Guid.NewGuid());

            _inner.Verify(s => s.Delete(It.IsAny<string>(), It.IsAny<Guid>()), Times.Once());
            Assert.IsTrue(watch.Elapsed < TimeSpan.FromSeconds(1.5));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Delete_Succeeds()
        {
            _service.Delete("account", Guid.NewGuid());

            _inner.Verify(s => s.Delete("account", It.IsAny<Guid>()), Times.Once());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PassThroughOperations_DelegateToInnerService()
        {
            var entity = new Entity("account");
            var collection = new EntityCollection();
            _inner.Setup(s => s.Retrieve(It.IsAny<string>(), It.IsAny<Guid>(), It.IsAny<ColumnSet>())).Returns(entity);
            _inner.Setup(s => s.RetrieveMultiple(It.IsAny<QueryBase>())).Returns(collection);

            Assert.AreSame(entity, _service.Retrieve("account", Guid.NewGuid(), new ColumnSet(true)));
            Assert.AreSame(collection, _service.RetrieveMultiple(new QueryExpression("account")));
            _service.Associate("account", Guid.NewGuid(), new Relationship("r"), new EntityReferenceCollection());
            _service.Disassociate("account", Guid.NewGuid(), new Relationship("r"), new EntityReferenceCollection());

            _inner.Verify(s => s.Associate(It.IsAny<string>(), It.IsAny<Guid>(), It.IsAny<Relationship>(), It.IsAny<EntityReferenceCollection>()), Times.Once());
            _inner.Verify(s => s.Disassociate(It.IsAny<string>(), It.IsAny<Guid>(), It.IsAny<Relationship>(), It.IsAny<EntityReferenceCollection>()), Times.Once());
        }
    }
}
