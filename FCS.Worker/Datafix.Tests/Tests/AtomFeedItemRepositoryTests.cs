namespace Datafix.Tests.Tests
{
    using System;
    using System.Configuration;
    using System.Data.SqlClient;
    using ContractManagement.DataStore.Model;
    using Dapper;
    using Datafix.Tests.Repositories;
    using Datafix.Tests.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Common.Serializers;

    [TestClass]
    public class AtomFeedItemRepositoryTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void AtomFeedItemRepository_ShouldReturnContracts()
        {
            var contracts = AtomFeedItemRepository.GetContracts();

            Assert.IsTrue(contracts.Count > 0);
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void AtomFeedItemRepository_ShouldInsert()
        {
            var contract = ContractService.GetCorpSchemaContract(new ContractIdentifier("MAIN-073", 1, 0));
            var xml = contract.SerializeToXml();
            var bytes = ZipHelper.ToZippedBytesFromString(xml);

            AtomFeedItemRepository.Insert(
                AtomItemType.ApprovedContract,
                contract.GetFirstContractNumber(),
                bytes);

            int i = 0;
        }


        [TestMethod, TestCategory("IntegationTest")]
        public void AtomFeedItemRepository_IsLatestPublishedEventAnApprovalIgnoringDraftAndWithdrawn_ShouldReturnFalseIfNotCorrect()
        {
            // arrange
            ClearAtomItems();
            var contractIdentifier = new ContractIdentifier("MAIN-1234", 1, 0);
            InsertAtomItem(contractIdentifier, AtomItemType.DraftContract);
            InsertAtomItem(contractIdentifier, AtomItemType.ApprovedContract);
            InsertAtomItem(contractIdentifier, AtomItemType.ClosedContract);

            // act
            bool isLatest =
                AtomFeedItemRepository.IsLatestPublishedEventAnApprovalIgnoringDraftAndWithdrawn(
                    contractIdentifier);
            
            // assert
            Assert.IsFalse(isLatest);
        }

        [TestMethod, TestCategory("IntegationTest")]
        public void AtomFeedItemRepository_IsLatestPublishedEventAnApprovalIgnoringDraftAndWithdrawn_ShouldReturnTrueIfCorrect()
        {
            // arrange
            ClearAtomItems();
            var contractIdentifier = new ContractIdentifier("MAIN-1234", 1, 0);
            InsertAtomItem(contractIdentifier, AtomItemType.DraftContract);
            InsertAtomItem(contractIdentifier, AtomItemType.ApprovedContract);
            InsertAtomItem(contractIdentifier, AtomItemType.WithdrawnContract);

            // act
            bool isLatest =
                AtomFeedItemRepository.IsLatestPublishedEventAnApprovalIgnoringDraftAndWithdrawn(
                    contractIdentifier);

            // assert
            Assert.IsTrue(isLatest);
        }

        private static void InsertAtomItem(ContractIdentifier contractIdentifier, AtomItemType itemType)
        {
            const string sql = @"INSERT INTO [ContractManagement].[AtomFeedItem]
                                (Identifier, ItemType, BusinessKey, AtomFeedItemXml, AtomFeedItemBytes, DuplicateIdentifier)
                                values (@identifier, @itemType, @businessKey, null, null, '00000000-0000-0000-0000-000000000000')
                                 ";
            string identifier = Guid.NewGuid().ToString();

            string businessKey =
                $"{contractIdentifier.ContractNumber}:{contractIdentifier.VersionNumber}.{contractIdentifier.SubVersionNumber}";
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
            using (var connection = new SqlConnection(connectionString))
            {
                connection.Execute(sql, param: new { businessKey, identifier, itemType });
            }
        }

        private static void ClearAtomItems()
        {
            const string sql = @"DELETE FROM[ContractManagement].[AtomFeedItem]";
          
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
            using (var connection = new SqlConnection(connectionString))
            {
                var itemTypes = connection.Execute(sql);
            }
        }
    }
}
