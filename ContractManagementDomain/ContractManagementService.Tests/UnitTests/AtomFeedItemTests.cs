namespace SFA.FCT.ContractManagementService.Test.UnitTests
{
    using System;
    using System.Collections.Generic;
    using System.Xml.Linq;
    using ContractManagement.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class AtomFeedItemTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void AtomFeedItem_ShouldNotCreateXml()
        {
            AtomFeedItem atomFeedItem = CreateAtomFeedItem();

            Assert.IsNull(atomFeedItem.AtomFeedItemXml, "Atom Feed Item XML was incorrectly populated");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AtomFeedItem_Get_ShouldGetXmlFromBytes()
        {
            AtomFeedItem atomFeedItem = CreateAtomFeedItem();

            Assert.IsNotNull(atomFeedItem.AtomFeedItemBytes, "Atom Feed Item Bytes was not created");

            // remove <?xml version... ?> tag
            var expected = XDocument.Parse(GetCorpContract().Serialize()).Root?.ToString();
            var actual = XDocument.Parse(atomFeedItem.GetAtomFeedItemXml()).Root?.ToString();
            
            Assert.IsNotNull(actual, "Could not retrieve XML from Atom Feed Item Bytes");
            Assert.AreEqual(expected, actual, "XML returned from GetAtomFeedItemXml was incorrect");
        }

        private AtomFeedItem CreateAtomFeedItem()
        {
            return AtomFeedItem.CreateAtomFeedItem(GetCorpContract(), "BK", AtomItemType.ApprovedContract, Guid.Empty, xml => true);
        }

        private Contract GetCorpContract()
        {
            return new Contract
            {
                contractNumber = "SFA-123",
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractNumber = "ABC-321",
                        contractVersionNumber = 1,
                        contractSubVersionNumber = 0,
                        contractAllocations = new List<contractAllocationsContractAllocation>()
                        {
                            new contractAllocationsContractAllocation
                            {
                                contractAllocationNumber = "Alloc1",
                                fundingStream = new fundingStream
                                {
                                    fundingStreamCode = "FCS1"
                                }
                            }
                        }
                    }
                }
            };
        }
    }
}