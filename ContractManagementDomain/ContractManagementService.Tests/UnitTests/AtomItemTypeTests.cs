namespace SFA.FCT.ContractManagementService.Test.UnitTests
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using ContractManagement.DataStore.Model;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractManagementService.AtomFeed;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract;

    [TestClass]
    public class AtomItemTypeTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void AtomItemType_ShouldHaveSyndicationItemCreatorForEach()
        {
            // arrange
            IEnumerable<AtomItemType> atomItemTypes = Enum.GetValues(typeof(AtomItemType)).Cast<AtomItemType>();
            AllContractAtomFeedSyndicationItemCreator syndicationItemCreator = new AllContractAtomFeedSyndicationItemCreator("");
            var contract = new Contract
            {
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        hierarchyType = hierarchyType.CONTRACT,
                        contractNumber = "X"
                    }
                }
            };

            // act
            try
            {
                atomItemTypes.Select(atomItemType => AtomFeedItem.CreateAtomFeedItem(contract, "", atomItemType, xml => true))
                    .ToList().ForEach(atomFeedItem => syndicationItemCreator.CreateItemForRow(atomFeedItem, ""));
            }
            catch (System.Collections.Generic.KeyNotFoundException)
            {
                // assert
                Assert.Fail($"We do not have a SyndicationItemCreator for one of the AtomItemTypes");
            }
        }
    }
}
