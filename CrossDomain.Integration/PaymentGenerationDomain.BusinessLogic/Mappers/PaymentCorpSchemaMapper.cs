namespace PaymentGenerationDomain.BusinessLogic.Mappers
{
    extern alias Entities;
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Xml.Linq;
    using System.Xml.Serialization;
    using Integration.DataStore.Model;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentGeneration;
    using PaymentGenerationDomain.Integration.DataStore.Dtos;

    public class PaymentCorpSchemaMapper : IPaymentCorpSchemaMapper
    {
        public PaymentPeriod MapSubnominalAggregationToCorpPaymentSchema(
            IReadOnlyCollection<SubnominalAggregationDto> subnominalAggregations,
            PaymentTimetable paymentTimetableDetails,
            IReadOnlyCollection<EsfAllocationData> esfAllocationData,
            string agency,
            DateTime fundingStreamPeriodStartDate,
            DateTime fundingStreamPeriodEndDate,
            string financeShortCode)
        {
            EsfAllocationData esfData;
            var paymentPeriod = new PaymentPeriod();
            var listOfAggregations = subnominalAggregations.ToList();
           
            paymentPeriod.Agency = agency;
            paymentPeriod.FundingStreamPeriodStartDate = fundingStreamPeriodStartDate;
            paymentPeriod.FundingStreamPeriodEndDate = fundingStreamPeriodEndDate;
            paymentPeriod.CensusEndDate = paymentTimetableDetails.CensusEndDate;
            paymentPeriod.DueDate = paymentTimetableDetails.PaymentDueDate;
            paymentPeriod.FundingStreamShortCode = financeShortCode; 
            paymentPeriod.FinancialPaymentFinancialMonth = paymentTimetableDetails.FinancialPeriod.Substring(4, 2); 
            paymentPeriod.FinancialPaymentFinancialYear = paymentTimetableDetails.FinancialPeriod.Substring(0, 4);
            
            listOfAggregations.ForEach(a =>
            {
                esfData = esfAllocationData.Any() 
                    ? esfAllocationData.FirstOrDefault(x => x.ContractAllocationNumber.ToUpper() == a.AllocationNumber.ToUpper())
                    : null;

                paymentPeriod.PaymentDetails.Add(CreatePaymentDetail(a, esfData));
            });

            return paymentPeriod;
        }

        public XDocument ToXml(PaymentPeriod paymentPeriodToConvert)
        {
            var serializer = new XmlSerializer(typeof(PaymentPeriod));

            XDocument responseXml;
            using (var xmlStream = new MemoryStream())
            {
                serializer.Serialize(xmlStream, paymentPeriodToConvert);
                xmlStream.Position = 0;
                responseXml = XDocument.Load(xmlStream, LoadOptions.PreserveWhitespace | LoadOptions.SetLineInfo);
            }

            return responseXml;
        }

        private static PaymentDetail CreatePaymentDetail(SubnominalAggregationDto currentAggregation, EsfAllocationData esfData)
        {
            return new PaymentDetail
            {
                Allocation = CreateAllocation(currentAggregation.AllocationNumber, currentAggregation.AllocationVersionNumber, esfData),
                SubnominalCode = currentAggregation.SubnominalCode,
                AggregatedValue = currentAggregation.AggregatedValue,
                SubnominalDescription = currentAggregation.ShortDescription,
                PaymentType = (PaymentDetailPaymentType)Enum.Parse(typeof(PaymentDetailPaymentType), currentAggregation.PaymentType.ToUpper()),
                Organisation = CreateOrganisation(currentAggregation.OrganisationId, currentAggregation.Ukprn.ToString())
            };
        }

        private static AllocationAttrsCT CreateAllocation(string allocationNumber, int allocationVersionNumber, EsfAllocationData esfData)
        {
            return new AllocationAttrsCT
            {
                AllocationNumber = allocationNumber,
                VersionNumber = allocationVersionNumber,
                ProcurementAttrs = esfData == null ? null : new ProcurementAttrsCT()
                {
                    LEPCode = esfData.LEPCode,
                    ActivityDescription =  esfData.ActivityDescription,
                    AgreementNumber = esfData.AgreementNumber,
                    AwardReference = esfData.AwardReference,
                    InvestmentPriority = esfData.InvestmentPriority,
                    LearningRatePremium = string.IsNullOrWhiteSpace(esfData.LearningRatePremium) ? 0m : decimal.Parse(esfData.LearningRatePremium),
                    LEPName = esfData.LEPName,
                    LotReference = esfData.LotReference,
                    LotSpecificationTitle = esfData.SpecificationTitle,
                    RegionType = esfData.RegionType,
                    TenderSpecReference = esfData.TenderSpecReference,
                    TenderSpecTitle = esfData.SpecificationTitle
                } 
            };
        }

        private static Organisation CreateOrganisation(string organisationId, string ukprn)
        {
            return new Organisation
            {
                OrganisationId = organisationId,
                AlternateOrganisationIdentifiers = new List<OrganisationIdentifier>
                {
                    new OrganisationIdentifier
                    {
                        AlternateOrganisationIdentifierName = OrganisationIdentifierAlternateOrganisationIdentifierName.UKPROVIDERREFERENCENUMBER,
                        AlternateOrganisationIdentifier = ukprn
                    }
                }, 
                OrganisationStatusRelationships = new List<OrganisationStatusRelationship>
                {
                    new OrganisationStatusRelationship()
                    {
                        // The Provider Table does not currently exist in the release, the Organisation Status can either be set in this schema, or the CODA schema
                    }
                }
            };
        }
    }
}
