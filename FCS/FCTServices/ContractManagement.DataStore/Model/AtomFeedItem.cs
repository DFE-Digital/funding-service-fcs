namespace ContractManagement.DataStore.Model
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Linq;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Common.Serializers;

    public class AtomFeedItem
    {
        private static readonly IReadOnlyCollection<AtomItemType> DuplicateAllowedItemType = new List<AtomItemType>
        {
            AtomItemType.ContractTerminationInitiated,
            AtomItemType.CancelledContractTermination,
            AtomItemType.ContractTerminationDetailsUpdated,
            AtomItemType.ContractModified,
            AtomItemType.ContractModificationCancelled
        };

        private AtomFeedItem()
        {
        }

        [Key]
        public int Id { get; set; }

        public Guid Identifier { get; private set; }

        [Index("IX_AtomFeedItem_ItemTypeBusinessKeyDuplicateIdentifier", IsUnique = true, Order = 0)]
        public AtomItemType ItemType { get; private set; }

        [Index("IX_AtomFeedItem_ItemTypeBusinessKeyDuplicateIdentifier", IsUnique = true, Order = 1)]
        public string BusinessKey { get; private set; }

        public string AtomFeedItemXml { get; private set; }

        public byte[] AtomFeedItemBytes { get; private set; }

        [Required, DatabaseGenerated(DatabaseGeneratedOption.Computed)]
        public DateTime CreatedDate { get; private set; }

        [Index("IX_AtomFeedItem_ItemTypeBusinessKeyDuplicateIdentifier", IsUnique = true, Order = 2)]
        public Guid DuplicateIdentifier { get; private set; }

        public static AtomFeedItem CreateAtomFeedItem<T>(T objectToStore, string businessKey, AtomItemType atomItemType, Func<string, bool> isValidXml) where T : class
        {
            return CreateAtomFeedItem(objectToStore, businessKey, atomItemType, feedItemId: Guid.NewGuid(), isValidXml);
        }

        public static AtomFeedItem CreateAtomFeedItem<T>(T objectToStore, string businessKey, AtomItemType atomItemType, Guid feedItemId, Func<string, bool> isValidXml) where T : class
        {
            var xml = objectToStore.SerializeToXml();
            if (!isValidXml(xml))
            {
                throw new ArgumentException($"The xml is not valid to the current schema for {businessKey}");
            }

            AtomFeedItem atomFeedItem = new AtomFeedItem
            {
                Identifier = feedItemId,
                ItemType = atomItemType,
                BusinessKey = businessKey,
                AtomFeedItemBytes = GetByteArrayForAtomItemObject(xml),
                DuplicateIdentifier = GetDuplicateIdentifierByAtomItemType(atomItemType, feedItemId)
            };

            return atomFeedItem;
        }

        public static AtomFeedItem CreateAtomFeedItem<T>(T objectToStore, string businessKey, AtomItemType atomItemType, DateTime createdDate) where T : class
        {
            var xml = objectToStore.SerializeToXml();
            AtomFeedItem atomFeedItem = new AtomFeedItem
            {
                Identifier = Guid.NewGuid(),
                ItemType = atomItemType,
                BusinessKey = businessKey,
                CreatedDate = createdDate,
                AtomFeedItemBytes = GetByteArrayForAtomItemObject(xml),
                DuplicateIdentifier = GetDuplicateIdentifierByAtomItemType(atomItemType, Guid.NewGuid())
            };

            return atomFeedItem;
        }

        public string GetAtomFeedItemXml()
        {
            return AtomFeedItemXml ?? ZipHelper.ToStringFromZippedBytes(AtomFeedItemBytes);
        }

        private static byte[] GetByteArrayForAtomItemObject(string xml)
        {
            return ZipHelper.ToZippedBytesFromString(xml);
        }

        private static Guid GetDuplicateIdentifierByAtomItemType(AtomItemType itemType, Guid feedItemId)
        {
            if (DuplicateAllowedItemType.Contains(itemType))
            {
                return feedItemId;
            }

            return Guid.Empty;
        }
    }
}