namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.Appendix_1
{
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using Common.Models;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using CrossDomain.Integration.Entities.CorporateContract;
    using DataStore;
    using DataStore.Repositories;
    using DocumentDefiner.DocumentConfiguration;
    using DocumentDefiner.DocumentPartCreators.Appendix1;
    using Integration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using Newtonsoft.Json;
    using PaymentManagementDomain.PolicyCache.DataStore;
    using UnitTests.Common;

    [TestClass]
    public class EfaAppendix1Test
    {
        public const string xml_10000976_1619LR1718_v1 = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><ctr:contract schemaVersion=\"8.00\" xsi:schemaLocation=\"contract D:\\TFS\\FCT\\Main\\Corporate\\Schemas\\contract_corporate_schema.xsd\" xmlns:ctr=\"urn:sfa:schemas:contract\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"><ctr:contracts><ctr:contract><ctr:fundingType><ctr:fundingTypeCode>1619FUND</ctr:fundingTypeCode><ctr:fundingTypeName/></ctr:fundingType><ctr:period><ctr:periodType><ctr:periodTypeCode>AY</ctr:periodTypeCode><ctr:periodTypeName>ACADEMIC YEAR</ctr:periodTypeName></ctr:periodType><ctr:period>1718</ctr:period><ctr:startDate>2017-08-01</ctr:startDate><ctr:endDate>2018-07-31</ctr:endDate></ctr:period><ctr:contractAllocations><ctr:contractAllocation><ctr:period><ctr:periodType><ctr:periodTypeCode>AY</ctr:periodTypeCode><ctr:periodTypeName>ACADEMIC YEAR</ctr:periodTypeName></ctr:periodType><ctr:period>1718</ctr:period><ctr:startDate>2017-08-01</ctr:startDate><ctr:endDate>2018-07-31</ctr:endDate></ctr:period><ctr:fundingStream><ctr:fundingStreamCode>1619LR</ctr:fundingStreamCode><ctr:fundingStreamName/><ctr:fundingTypeCode>1</ctr:fundingTypeCode><ctr:fundingStreamShortCode>16LR</ctr:fundingStreamShortCode></ctr:fundingStream><ctr:contractDeliverables><ctr:contractDeliverable><ctr:deliverable><ctr:fundingStreamCode>1619LR</ctr:fundingStreamCode><ctr:deliverableCode>19</ctr:deliverableCode></ctr:deliverable><ctr:contractDeliverablePeriods><ctr:contractDeliverablePeriod><ctr:year>2017</ctr:year><ctr:period>8</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>31946.02</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2017</ctr:year><ctr:period>9</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>0.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2017</ctr:year><ctr:period>10</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>-1582.01</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2017</ctr:year><ctr:period>11</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>45126.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2017</ctr:year><ctr:period>12</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>42849.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2018</ctr:year><ctr:period>1</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>54090.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2018</ctr:year><ctr:period>2</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>24009.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2018</ctr:year><ctr:period>3</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>52701.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2018</ctr:year><ctr:period>4</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>33154.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2018</ctr:year><ctr:period>5</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>0.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2018</ctr:year><ctr:period>6</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>58786.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2018</ctr:year><ctr:period>7</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>24067.00</ctr:plannedValue></ctr:contractDeliverablePeriod></ctr:contractDeliverablePeriods><ctr:deliverableDescription>16-19 Bursary Funds</ctr:deliverableDescription></ctr:contractDeliverable></ctr:contractDeliverables><ctr:contractAllocationNumber>1619LR-3928</ctr:contractAllocationNumber><ctr:description>16-19 Learner Responsive Funding</ctr:description><ctr:hierarchyType>CONTRACT ALLOCATION</ctr:hierarchyType><ctr:fundingStreamPeriodCode>1619LR1718</ctr:fundingStreamPeriodCode><ctr:startDate>2017-08-01</ctr:startDate><ctr:endDate>2018-07-31</ctr:endDate></ctr:contractAllocation></ctr:contractAllocations><ctr:contractNumber>1619FUND-1</ctr:contractNumber><ctr:contractVersionNumber>1</ctr:contractVersionNumber><ctr:contractor><ctr:organisationIdentifier>0</ctr:organisationIdentifier><ctr:ukprn>10000976</ctr:ukprn><ctr:legalName>BUCKINGHAMSHIRE COUNTY COUNCIL</ctr:legalName><ctr:Upin>1234</ctr:Upin></ctr:contractor><ctr:hierarchyType>CONTRACT</ctr:hierarchyType><ctr:startDate>2017-08-01</ctr:startDate><ctr:endDate>2018-07-31</ctr:endDate><ctr:contractStatus><ctr:status>DRAFT</ctr:status><ctr:parentStatus>DRAFT</ctr:parentStatus></ctr:contractStatus><ctr:contractValue>594550</ctr:contractValue></ctr:contract></ctr:contracts><ctr:fundingType><ctr:fundingTypeCode>1619FUND</ctr:fundingTypeCode><ctr:fundingTypeName/></ctr:fundingType><ctr:contractNumber>SFA-9009</ctr:contractNumber><ctr:contractVersionNumber>1</ctr:contractVersionNumber><ctr:contractor><ctr:organisationIdentifier>0</ctr:organisationIdentifier><ctr:ukprn>10000976</ctr:ukprn><ctr:legalName>BUCKINGHAMSHIRE COUNTY COUNCIL</ctr:legalName></ctr:contractor><ctr:hierarchyType>MASTER CONTRACT</ctr:hierarchyType><ctr:contractStatus><ctr:status>DRAFT</ctr:status><ctr:parentStatus>DRAFT</ctr:parentStatus></ctr:contractStatus></ctr:contract>";
        
        [TestMethod, TestCategory("UnitTest")]
        public void TestThatDocumentPartIsRequiredForEsf()
        {
            Contract masterContract = TestHelpers.GetObjectFromXml<Contract>(xml_10000976_1619LR1718_v1);
            EfaApendix1 classUnderTest = new EfaApendix1(null, null, null, null, null);
            Assert.IsTrue(classUnderTest.IsDocumentPartRequired(masterContract.contracts.First()));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestThatHeaderIsNotRequiredForEfaAppendix1()
        {
            Assert.IsFalse(new EfaApendix1(null, null, null, null, null).IsHeaderDocumentRequired);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void EfaAppendix1_ShouldGroupAndOrderDeliverables()
        {
            // arrange
            Mock<IFundingTypeFundingPeriodQueryRepository> fundingTypeFundingPeriodRepositoryMock = new Mock<IFundingTypeFundingPeriodQueryRepository>();
            Mock<ITemplateRepository> templateRepository = new Mock<ITemplateRepository>();
            
            fundingTypeFundingPeriodRepositoryMock.Setup(r => r.Get(It.IsAny<string>(), It.IsAny<string>()))
                .Returns(new FundingTypeFundingPeriod());

            IDictionary<string, DocumentGenerationRequest> requests;
            Contract contract = GetCorporateContract("corpContractEfa.json");
            var numRepeatingSections =
                contract.contractAllocations.SelectMany(
                    ca => ca.contractDeliverables.Select(cd => cd.deliverable.deliverableName)).Distinct().Count();

            using (var paymentManagementPolicyContext = new PaymentManagementPolicyContext())
            using (var documentDomainDbContext = new DocumentsDomainDbContext())
            {
                EfaApendix1 apendix1 = new EfaApendix1(
                templateRepository.Object,
                new DocumentConfigurationSource(new FundingStreamPeriodRepository(documentDomainDbContext), new FspDeliverableRepository(documentDomainDbContext), new FundingTypeFundingPeriodRepository(documentDomainDbContext)),
                fundingTypeFundingPeriodRepositoryMock.Object,
                paymentManagementPolicyContext,
                new FundingStreamPeriodRepository(documentDomainDbContext));
                
                // act
                requests = apendix1.SupplyDocumentGenerationRequest("", contract, "");
            }

            // assert
            List<RowType> rows = requests.Values.First().MergeData.RepeatingSections.First().Rows;
            Assert.AreEqual(numRepeatingSections, rows.Count, "The number of rows in the repeating section is incorrect");

            string firstDeliverableName = rows[0].MergeFields[0].Value;

            // 1619LR1718 deliverables should be before NMF1718
            string fsp = GetFundingStreamForDeliverableName(firstDeliverableName);
            Assert.AreEqual("1619LR1718", fsp, "The display order has not worked for the first allocation");
            fsp = GetFundingStreamForDeliverableName(rows.Last().MergeFields[0].Value);
            Assert.AreEqual("NMF1718", fsp, "The display order has not worked for the last allocation");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void EfaAppendix1_ShouldGetCorrectTotalRow()
        {
            // arrange
            Mock<IFundingTypeFundingPeriodQueryRepository> fundingTypeFundingPeriodRepositoryMock = new Mock<IFundingTypeFundingPeriodQueryRepository>();
            Mock<ITemplateRepository> templateRepository = new Mock<ITemplateRepository>();

            fundingTypeFundingPeriodRepositoryMock.Setup(r => r.Get(It.IsAny<string>(), It.IsAny<string>()))
                .Returns(new FundingTypeFundingPeriod());

            IDictionary<string, DocumentGenerationRequest> requests;
            Contract contract = GetCorporateContract("DocumentSaveCommand_10008865.json");
           
            using (var paymentManagementPolicyContext = new PaymentManagementPolicyContext())
            using (var documentDomainDbContext = new DocumentsDomainDbContext())
            {
                EfaApendix1 apendix1 = new EfaApendix1(
                templateRepository.Object,
                new DocumentConfigurationSource(new FundingStreamPeriodRepository(documentDomainDbContext), new FspDeliverableRepository(documentDomainDbContext), new FundingTypeFundingPeriodRepository(documentDomainDbContext)),
                fundingTypeFundingPeriodRepositoryMock.Object,
                paymentManagementPolicyContext,
                new FundingStreamPeriodRepository(documentDomainDbContext));

                // act
                requests = apendix1.SupplyDocumentGenerationRequest("", contract, "");
            }

            // assert
            MergeFieldType mergeFieldTypeT1 = requests.Values.First()
                .MergeData.MergeFields.Single(mf => mf.Name == "T1");
            Assert.AreEqual("105816.19", mergeFieldTypeT1.Value, "The column value for T1 is incorrect");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void EfaAppendix1_ShouldPutTotalsInCorrectIndexesForPeriod()
        {
            // arrange
            Mock<IFundingTypeFundingPeriodQueryRepository> fundingTypeFundingPeriodRepositoryMock = new Mock<IFundingTypeFundingPeriodQueryRepository>();
            Mock<ITemplateRepository> templateRepository = new Mock<ITemplateRepository>();

            fundingTypeFundingPeriodRepositoryMock.Setup(r => r.Get(It.IsAny<string>(), It.IsAny<string>()))
                .Returns(new FundingTypeFundingPeriod());

            string[] mergeFieldsShouldNotBePresent = {"T1", "T2", "T3", "T6", "T7", "T8", "T9", "T10", "T11", "T12"};
            string[] mergeFieldsShouldBePresent = {"T4", "T5"};

            IDictionary<string, DocumentGenerationRequest> requests;
            Contract contract = GetShortCorporateContract();

            using (var paymentManagementPolicyContext = new PaymentManagementPolicyContext())
            using (var documentDomainDbContext = new DocumentsDomainDbContext())
            {
                EfaApendix1 apendix1 = new EfaApendix1(
                templateRepository.Object,
                new DocumentConfigurationSource(new FundingStreamPeriodRepository(documentDomainDbContext), new FspDeliverableRepository(documentDomainDbContext), new FundingTypeFundingPeriodRepository(documentDomainDbContext)),
                fundingTypeFundingPeriodRepositoryMock.Object,
                paymentManagementPolicyContext,
                new FundingStreamPeriodRepository(documentDomainDbContext));

                // act
                requests = apendix1.SupplyDocumentGenerationRequest("", contract, "");
            }

            // assert
            Assert.IsTrue(requests.Values.Any(r => mergeFieldsShouldBePresent.All(m => r.MergeData.MergeFields.Any(f => f.Name == m))), "Totals are missing from the expected columns");
            Assert.IsFalse(requests.Values.Any(r => r.MergeData.MergeFields.Any(md => mergeFieldsShouldNotBePresent.Contains(md.Name))), "Totals are in the wrong columns");
        }

        private Contract GetCorporateContract(string fileName)
        {
            using (var resource = new TestResource("SFA.FCT.DocumentsDomain.DocumentGeneration.Tests", $@"Resources.{fileName}"))
            {
                return
                    (Contract)
                        new JsonSerializer().Deserialize(new StreamReader(resource.Stream), typeof(Contract));
            }
        }

        private Contract GetShortCorporateContract()
        {
            using (var resource = new TestResource("SFA.FCT.DocumentsDomain.DocumentGeneration.Tests", @"Resources.shortCorpContractEfa.json"))
            {
                return
                    (Contract)
                        new JsonSerializer().Deserialize(new StreamReader(resource.Stream), typeof(Contract));
            }
        }

        private string GetFundingStreamForDeliverableName(string deliverableName)
        {
            string fsp = null;

            if (deliverableName == "16+ Factor Removal (DSG) SSF")
            {
                fsp = "NMF1718";
            }
            else if (deliverableName == "16-19 Total Programme Funding")
            {
                fsp = "1619LR1718";
            }

            return fsp;
        }
    }
}