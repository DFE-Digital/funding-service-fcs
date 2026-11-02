namespace SFA.FCT.ContractManagementService.AtomFeed
{
    using System;
    using System.Diagnostics.CodeAnalysis;
    using System.IO;
    using System.ServiceModel.Syndication;
    using System.Xml;
    using CrossDomain.Integration.Common.Extensions;
    using global::ContractManagementService.AtomFeed;
    using global::ContractManagementService.DTOs;

    public class AllocationDeliveryFeedSyndicationItemCreator : ISyndicationItemCreator<AllocationDeliveryEntry>  
    {
        public SyndicationItem CreateItemForRow(AllocationDeliveryEntry row, string mediaType)
        {
            XmlTextReader xmlTextReader = new XmlTextReader(new StringReader(row.GetAllocationDeliveryPerformanceXml()));
            SyndicationElementExtension syndicationElementExtension = new SyndicationElementExtension(xmlTextReader);
            var item = new SyndicationItem
            {
                Content = new XmlSyndicationContent("application/vnd.sfa.allocation-delivery.allocation-delivery-performance.v1+xml", syndicationElementExtension),
                Id = string.Format("uuid:{0}", row.Identifier),
                PublishDate = row.CreatedDate,
                LastUpdatedTime = row.CreatedDate,
                Title = new TextSyndicationContent(GetTitleText(row)),
            };

            item.Categories.Add(new SyndicationCategory(row.AllocationDeliveryCategory.ToString(), null, row.AllocationDeliveryCategory.GetDescription()));

            return item;
        }

        [ExcludeFromCodeCoverage]
        private string GetTitleText(AllocationDeliveryEntry row)
        {
            switch (row.AllocationDeliveryCategory)
            {
                case AllocationDeliveryEntryCategory.NewContractAllocationApproved:
                    return $"New Contract {row.ContractNumber}: {row.VersionNumber}.{row.SubVersionNumber} with Allocation {row.AllocationNumber} was Approved";
                case AllocationDeliveryEntryCategory.AmendedContractAllocationApproved:
                    return $"Amendment to Contract {row.ContractNumber}: {row.VersionNumber}.{row.SubVersionNumber} with Allocation {row.AllocationNumber} was Approved";
                case AllocationDeliveryEntryCategory.ContractAllocationActualsReceived:
                    return $"Actuals for Allocation {row.AllocationNumber} of Contract {row.ContractNumber}: {row.VersionNumber}.{row.SubVersionNumber} have been received";
                case AllocationDeliveryEntryCategory.ContractAllocationPaymentReceived:
                    return $"Payment for Allocation {row.AllocationNumber} of Contract {row.ContractNumber}: {row.VersionNumber}.{row.SubVersionNumber} have been posted";
                case AllocationDeliveryEntryCategory.ContractAllocationActualsUpdated:
                    return $"Actuals for Allocation {row.AllocationNumber} of Contract {row.ContractNumber}: {row.VersionNumber}.{row.SubVersionNumber} have been updated";
                default:
                    throw new ArgumentException($"Unknown AllocationDeliveryCategory generating summary - {row.AllocationDeliveryCategory}");
            }
        }
    }
}
