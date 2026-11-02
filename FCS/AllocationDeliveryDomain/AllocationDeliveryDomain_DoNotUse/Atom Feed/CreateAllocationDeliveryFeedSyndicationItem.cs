namespace SFA.FCT.AllocationDeliveryDomain.Atom_Feed
{
    using SFA.FCT.AllocationDelivery.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Common.Atom.CreateSyndicationItem;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using System;
    using System.Diagnostics.CodeAnalysis;
    using System.IO;
    using System.ServiceModel.Syndication;
    using System.Xml;

    //TODO: rename CreateXxxSyndicationItem -> XxxSyndicationItemCreator (or factory, or command or sumfink?)

    public class CreateAllocationDeliveryFeedSyndicationItem : CreateSyndicationItemBase<AllocationDeliveryPerformance, AllocationDeliveryEntryContent>, ICreateSyndicationItem<AllocationDeliveryEntry>
    {
        public SyndicationItem CreateItemForRow(AllocationDeliveryEntry row, string mediaType)
        {
            SyndicationItem item;
            var a = SerializeRowToXml(row.CorporateAllocationDelivery);

                item = new SyndicationItem()
                {
                    Content = new XmlSyndicationContent(new XmlTextReader(new StringReader(SerializeRowToXml( row.CorporateAllocationDelivery)))),
                    Summary = new TextSyndicationContent(GetSummaryText(row)),
                    //TODO: required?
                    //Id = Guid.NewGuid().ToString("D")
                    LastUpdatedTime = row.CreatedDate
                };
            //TODO: http://stackoverflow.com/questions/479410/enum-tostring-with-user-friendly-strings for label
            item.Categories.Add(new SyndicationCategory(row.AllocationDeliveryCategory.ToString(), null, row.AllocationDeliveryCategory.GetDescription()));

            item.Links.Add(CreateSyndicationLink(mediaType));
            return item;
        }

        [ExcludeFromCodeCoverage]
        protected string GetSummaryText(AllocationDeliveryEntry row)
        {
            switch (row.AllocationDeliveryCategory)
            {
                case AllocationDeliveryEntryCategory.NewContractAllocationApproved:
                    return string.Format("New Contract {0}: {1}.{2} with Allocation {3} was Approved", row.CorporateAllocationDelivery.Contract.contractNumber, row.CorporateAllocationDelivery.Contract.contractVersionNumber, row.CorporateAllocationDelivery.Contract.contractSubVersionNumber, row.CorporateAllocationDelivery.contractAllocationNumber);
                case AllocationDeliveryEntryCategory.AmendedContractAllocationApproved:
                    return string.Format("Amendment to Contract {0}: {1}.{2} with Allocation {3} was Approved", row.CorporateAllocationDelivery.Contract.contractNumber, row.CorporateAllocationDelivery.Contract.contractVersionNumber, row.CorporateAllocationDelivery.Contract.contractSubVersionNumber, row.CorporateAllocationDelivery.contractAllocationNumber);
                case AllocationDeliveryEntryCategory.ContractAllocationActualsReceived:
                    return string.Format("Actuals for Allocation {0} of Contract {1}: {2}.{3} have been receieved", row.CorporateAllocationDelivery.contractAllocationNumber, row.CorporateAllocationDelivery.Contract.contractNumber, row.CorporateAllocationDelivery.Contract.contractVersionNumber, row.CorporateAllocationDelivery.Contract.contractSubVersionNumber);
                case AllocationDeliveryEntryCategory.ContractAllocationPaymentReceived:
                    return string.Format("Payment for Allocation {0} of Contract {1}: {2}.{3} have been posted", row.CorporateAllocationDelivery.contractAllocationNumber, row.CorporateAllocationDelivery.Contract.contractNumber, row.CorporateAllocationDelivery.Contract.contractVersionNumber, row.CorporateAllocationDelivery.Contract.contractSubVersionNumber);
                default:
                    throw new Exception("Unknown AllocationDeliveryCategory generating summary");
            }
        }
    }
}
