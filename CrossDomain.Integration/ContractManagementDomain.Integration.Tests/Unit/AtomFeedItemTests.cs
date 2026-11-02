namespace SFA.FCT.ContractManagementDomain.Integration.Tests.Unit
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using ContractManagement.DataStore.Model;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class AtomFeedItemTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void AtomFeedItem_Create_ShouldHaveEmptyGuidDuplicateIdentifierForNotRepeatedItemTypes()
        {
            // arrange
            IReadOnlyCollection<AtomItemType> nonRepeatedItemTypes = new List<AtomItemType>
            {
                AtomItemType.WithdrawnContract,
                AtomItemType.ApprovedContract,
                AtomItemType.ClosedContract,
                AtomItemType.DraftContract
            };

            // act
            IReadOnlyCollection<AtomFeedItem> atomFeedItems =
                nonRepeatedItemTypes
                    .Select(ait => AtomFeedItem.CreateAtomFeedItem("DummyItem", "ABC:123", ait, xml => true))
                    .ToList();

            // assert
            Assert.IsTrue(atomFeedItems.All(item => item.DuplicateIdentifier == Guid.Empty),
                "An item was created with a non-empty GUID for the duplicate identifier");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AtomFeedItem_Create_ShouldHaveNonEmptyGuidDuplicateIdentifierForRepeatedItemTypes()
        {
            // arrange
            IReadOnlyCollection<AtomItemType> repeatedItemTypes = new List<AtomItemType>
            {
                AtomItemType.ContractTerminationInitiated,
                AtomItemType.CancelledContractTermination
            };

            // act
            IReadOnlyCollection<AtomFeedItem> atomFeedItems =
                repeatedItemTypes
                    .Select(ait => AtomFeedItem.CreateAtomFeedItem("DummyItem", "ABC:123", ait, xml => true))
                    .ToList();

            // assert
            Assert.IsFalse(atomFeedItems.Any(item => item.DuplicateIdentifier == Guid.Empty),
                "An item was created with an empty GUID for the duplicate identifier");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AtomFeedItem_CreateWithDate_ShouldHaveEmptyGuidDuplicateIdentifierForNotRepeatedItemTypes()
        {
            // arrange
            IReadOnlyCollection<AtomItemType> nonRepeatedItemTypes = new List<AtomItemType>
            {
                AtomItemType.WithdrawnContract,
                AtomItemType.ApprovedContract,
                AtomItemType.ClosedContract,
                AtomItemType.DraftContract
            };

            // act
            IReadOnlyCollection<AtomFeedItem> atomFeedItems =
                nonRepeatedItemTypes
                    .Select(ait => AtomFeedItem.CreateAtomFeedItem("DummyItem", "ABC:123", ait, DateTime.Now))
                    .ToList();

            // assert
            Assert.IsTrue(atomFeedItems.All(item => item.DuplicateIdentifier == Guid.Empty),
                "An item was created with a non-empty GUID for the duplicate identifier");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AtomFeedItem_CreateWithDate_ShouldHaveNonEmptyGuidDuplicateIdentifierForRepeatedItemTypes()
        {
            // arrange
            IReadOnlyCollection<AtomItemType> repeatedItemTypes = new List<AtomItemType>
            {
                AtomItemType.ContractTerminationInitiated,
                AtomItemType.CancelledContractTermination
            };

            // act
            IReadOnlyCollection<AtomFeedItem> atomFeedItems =
                repeatedItemTypes
                    .Select(ait => AtomFeedItem.CreateAtomFeedItem("DummyItem", "ABC:123", ait, DateTime.Now))
                    .ToList();

            // assert
            Assert.IsFalse(atomFeedItems.Any(item => item.DuplicateIdentifier == Guid.Empty),
                "An item was created with an empty GUID for the duplicate identifier");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AtomFeedItem_CreateWithId_ShouldHaveEmptyGuidDuplicateIdentifierForNotRepeatedItemTypes()
        {
            // arrange
            IReadOnlyCollection<AtomItemType> nonRepeatedItemTypes = new List<AtomItemType>
            {
                AtomItemType.WithdrawnContract,
                AtomItemType.ApprovedContract,
                AtomItemType.ClosedContract,
                AtomItemType.DraftContract
            };

            // act
            IReadOnlyCollection<AtomFeedItem> atomFeedItems =
                nonRepeatedItemTypes
                    .Select(ait => AtomFeedItem.CreateAtomFeedItem("DummyItem", "ABC:123", ait, Guid.NewGuid(), xml => true))
                    .ToList();

            // assert
            Assert.IsTrue(atomFeedItems.All(item => item.DuplicateIdentifier == Guid.Empty),
                "An item was created with a non-empty GUID for the duplicate identifier");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AtomFeedItem_CreateWithId_ShouldHaveNonEmptyGuidDuplicateIdentifierForRepeatedItemTypes()
        {
            // arrange
            IReadOnlyCollection<AtomItemType> repeatedItemTypes = new List<AtomItemType>
            {
                AtomItemType.ContractTerminationInitiated,
                AtomItemType.CancelledContractTermination,
                AtomItemType.ContractTerminationDetailsUpdated
            };

            // act
            IReadOnlyCollection<AtomFeedItem> atomFeedItems =
                repeatedItemTypes
                    .Select(ait => AtomFeedItem.CreateAtomFeedItem("DummyItem", "ABC:123", ait, Guid.NewGuid(), xml => true))
                    .ToList();

            // assert
            Assert.IsFalse(atomFeedItems.Any(item => item.DuplicateIdentifier == Guid.Empty),
                "An item was created with an empty GUID for the duplicate identifier");
        }
    }
}

