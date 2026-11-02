namespace SFA.FCT.ContractManagementDomain.Integration.Tests.Unit
{
    using System;
    using System.Data;
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    using System.Data.SqlClient;
    using System.Linq;
    using System.Reflection;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Exceptions;
    using ContractManagement.DataStore.Model;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using ContractManagement.DataStore.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    [TestClass]
    public class AtomItemRepositoryTests
    {
        private const string TestBusinessKey = "TestKey:1:0";
        private Mock<IContractManagementDbContext> _contextMock;
        private Mock<IDbSet<AtomFeedItem>> _dbSetMock;

        [TestInitialize]
        public void TestInitialize()
        {
            _contextMock = new Mock<IContractManagementDbContext>();
            _dbSetMock = new Mock<IDbSet<AtomFeedItem>>();
            _contextMock.Setup(c => c.Connection).Returns(Mock.Of<IDbConnection>());
        }

        [TestMethod, TestCategory("UnitTest"), ExpectedException(typeof(SqlDuplicateKeyStorageException))]
        public void Calling_AddAtomItem_ExpectDbUpdateExceptionToBeCalledWhenHasInnerExceptionandContainsDuplicateSqlException()
        {
            AtomFeedItem item = AtomFeedItem.CreateAtomFeedItem(new contract(), TestBusinessKey,
                   AtomItemType.ApprovedContract, xml => true);

            var sqlException = ReturnMockSqlException(2601);

            IAtomItemRepository repository = new ApprovedContractAtomItemRepository(_contextMock.Object);
            _contextMock.Setup(c => c.AtomFeedItems).Returns(_dbSetMock.Object);
            var exception = new DbUpdateException(string.Empty, new NullReferenceException(string.Empty, sqlException));
            _contextMock.Setup(c => c.SaveChanges()).Throws(exception);

            repository.Add(item);
        }

        [TestMethod, TestCategory("UnitTest"), ExpectedException(typeof (InvalidOperationException))]
        public void Calling_AddAtomItem_ExpectInvalidOperationExceptionToBeCalledWhenNoInnerExceptionandNotDupicateException()
        {
            AtomFeedItem item = AtomFeedItem.CreateAtomFeedItem(new contract(), TestBusinessKey,
                   AtomItemType.ApprovedContract, xml => true);
            
            IAtomItemRepository repository = new ApprovedContractAtomItemRepository(_contextMock.Object);
            _contextMock.Setup(c => c.AtomFeedItems).Returns(_dbSetMock.Object);
            _contextMock.Setup(c => c.SaveChanges()).Throws(new InvalidOperationException());

            repository.Add(item);
        }

        [TestMethod, TestCategory("UnitTest"), ExpectedException(typeof(DbUpdateException))]
        public void Calling_AddAtomItem_ExpectDbUpdateExceptionToBeCalledWhenNoInnerException()
        {
            AtomFeedItem item = AtomFeedItem.CreateAtomFeedItem(new contract(), TestBusinessKey,
                   AtomItemType.ApprovedContract, xml => true);

            IAtomItemRepository repository = new ApprovedContractAtomItemRepository(_contextMock.Object);
            _contextMock.Setup(c => c.AtomFeedItems).Returns(_dbSetMock.Object);
            _contextMock.Setup(c => c.SaveChanges()).Throws(new DbUpdateException());

            repository.Add(item);
        }

        [TestMethod, TestCategory("UnitTest"), ExpectedException(typeof(DbUpdateException))]
        public void Calling_AddAtomItem_ExpectDbUpdateExceptionToBeCalledWhenHasInnerExceptionbutNotDuplicateException()
        {
            AtomFeedItem item = AtomFeedItem.CreateAtomFeedItem(new contract(), TestBusinessKey,
                   AtomItemType.ApprovedContract, xml => true);

            IAtomItemRepository repository = new ApprovedContractAtomItemRepository(_contextMock.Object);
            _contextMock.Setup(c => c.AtomFeedItems).Returns(_dbSetMock.Object);
            var exception = new DbUpdateException(string.Empty, new NullReferenceException());
            _contextMock.Setup(c => c.SaveChanges()).Throws(new DbUpdateException());

            repository.Add(item);
        }

        [TestMethod, TestCategory("UnitTest"), ExpectedException(typeof(DbUpdateException))]
        public void Calling_AddAtomItem_ExpectDbUpdateExceptionToBeCalledWhenHasInnerExceptionbutNotDuplicateSqlException()
        {
            AtomFeedItem item = AtomFeedItem.CreateAtomFeedItem(new contract(), TestBusinessKey,
                   AtomItemType.ApprovedContract, xml => true);

            var sqlException = ReturnMockSqlException(1);

            IAtomItemRepository repository = new ApprovedContractAtomItemRepository(_contextMock.Object);
            _contextMock.Setup(c => c.AtomFeedItems).Returns(_dbSetMock.Object);
            var exception = new DbUpdateException(string.Empty, new NullReferenceException(string.Empty, sqlException));
            _contextMock.Setup(c => c.SaveChanges()).Throws(exception);

            repository.Add(item);
        }

        private static SqlException ReturnMockSqlException(int errorNumber)
        {
            SqlErrorCollection collection = Construct<SqlErrorCollection>();
            SqlError error = Construct<SqlError>(errorNumber, (byte) 2, (byte) 3, "server name", "error message", "proc", 100);

            typeof (SqlErrorCollection)
                .GetMethod("Add", BindingFlags.NonPublic | BindingFlags.Instance)
                .Invoke(collection, new object[] {error});

            var sqlException = typeof (SqlException)
                .GetMethod("CreateException", BindingFlags.NonPublic | BindingFlags.Static,
                    null,
                    CallingConventions.ExplicitThis,
                    new[] {typeof (SqlErrorCollection), typeof (string)},
                    new ParameterModifier[] {})
                .Invoke(null, new object[] {collection, "7.0.0"}) as SqlException;
            return sqlException;
        }

        private static T Construct<T>(params object[] p)
        {
            var ctors = typeof(T).GetConstructors(BindingFlags.NonPublic | BindingFlags.Instance);
            return (T)ctors.First(ctor => ctor.GetParameters().Length == p.Length).Invoke(p);
        }

        [TestCleanup]
        public void TestCleanUp()
        {
            _contextMock = null;
            _dbSetMock = null;
        }
    }
}
