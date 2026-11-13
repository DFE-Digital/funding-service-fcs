namespace SFA.FCT.ContractManagementService.Test.UnitTests
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Xml;
    using System.Xml.Linq;
    using System.Xml.Schema;
    using System.Xml.Serialization;
    using Common;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using CorporateContract = CrossDomain.Integration.Entities.CorporateContract;
    using CorporateSchema = CrossDomain.Integration.Entities.CorporateSchema.Contract;

    [TestClass]
    public class ContractRequestTransformerTest
    {
        private const string CorpContractSchemaNamespace = "urn:sfa:schemas:contract";
        private const string CorpContractSchemaResourceName = "SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.contract_corporate_schema_v11.08.xsd";

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldTransformCorporateContractToCorporateSchemaContract()
        {
            var transformer = new ContractTransformer();
            var corporatecontract = GetContract();
            var contract = transformer.TransformToCorporateSchemaContract(corporatecontract);
            Assert.IsTrue(contract != null);
            
            // Master Contract
            Assert.IsTrue(contract.contractNumber != string.Empty, "Master Contract Number is not returned correctly");
            Assert.IsTrue(contract.fundingType != null, "Master Funding Type is null");
            Assert.IsTrue(contract.fundingType.fundingTypeCode == corporatecontract.fundingType.fundingTypeCode, "Funding Type is not returned correctly");
            Assert.IsTrue(contract.contractType1 == corporatecontract.contractType1, "Contract Type is not returned correctly");
            Assert.IsTrue(contract.contractor != null, "Master Contractor is not returned correctly");
            Assert.IsTrue(contract.contractor.ukprn == corporatecontract.contractor.ukprn, "MasterContractor UKPRN is not returned correctly");
            Assert.IsTrue(contract.contractor.legalName == corporatecontract.contractor.legalName, "Master Contractor Provider Name is not returned correctly");
            Assert.IsTrue(contract.contractor.organisationIdentifier == corporatecontract.contractor.organisationIdentifier, "Master Contractor Org ID is not returned correctly");

            foreach (var subContract in corporatecontract.contracts)
            {
                Assert.IsTrue(subContract.contractNumber != string.Empty, "Contract Number is not returned correctly");
                Assert.IsTrue(subContract.fundingType.fundingTypeCode == corporatecontract.fundingType.fundingTypeCode, "Funding Type is not returned correctly");
                Assert.IsTrue(subContract.contractType1 == corporatecontract.contractType1, "Contract Type is not returned correctly");
                Assert.IsTrue(subContract.contractor != null, "Contractor is not returned correctly");
                Assert.IsTrue(subContract.contractor.ukprn == corporatecontract.contractor.ukprn, "Contractor UKPRN is not returned correctly");
                Assert.IsTrue(subContract.contractor.legalName == corporatecontract.contractor.legalName, "Contractor Provider Name is not returned correctly");
                Assert.IsTrue(subContract.contractor.organisationIdentifier == corporatecontract.contractor.organisationIdentifier, "Contractor Org ID is not returned correctly");
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldValidateTransformedCorporateSchemaContract()
        {
            var transformer = new ContractTransformer();
            var corporatecontract = GetContract();

            var contract = transformer.TransformToCorporateSchemaContract(corporatecontract);

            XmlSchemaSet schemas = new XmlSchemaSet();
            AddSchemasToSet(schemas);

            XmlSerializer serializer = new XmlSerializer(typeof(CrossDomain.Integration.Entities.CorporateSchema.Contract.Contract));

            XDocument responseXml;
            using (MemoryStream xmlStream = new MemoryStream())
            {
                serializer.Serialize(xmlStream, contract);
                xmlStream.Position = 0;
                responseXml = XDocument.Load(xmlStream, LoadOptions.PreserveWhitespace | LoadOptions.SetLineInfo);
            }

            responseXml.Validate(
                schemas,
                (o, e) =>
                {
                   Assert.Fail(e.Message);
                });
        }

        private void AddSchemasToSet(XmlSchemaSet schemas)
        {
            Stream xsdStream = GetCorporateSchemaXsdFile();
            schemas.Add(CorpContractSchemaNamespace, new XmlTextReader(xsdStream));
        }

        public static Stream GetCorporateSchemaXsdFile()
        {
            return typeof(CrossDomain.Integration.Entities.CorporateSchema.Contract.Contract).Assembly.GetManifestResourceStream(CorpContractSchemaResourceName);
        }

        private CorporateContract.Contract GetContract()
        {
            var corporateContract = new CorporateContract.Contract()
            {
                schemaVersion = new Decimal(10.07),
                contractNumber = "123456",
                fundingType = new CorporateContract.fundingType
                {
                    fundingTypeCode = "AAA",
                    fundingTypeName = "TT"
                },
                contractor = CreateContractor(),
                fundingStream = CreateFundingStream(),
                period = CreatePeriod(),
                contractType1 = "Contract Type",
                startDate = GetDate(),
                endDate = GetDate(),
                contractStatus = CreateContractStatus(),
                contracts = new List<CorporateContract.contractType>
                {
                    new CorporateContract.contractType()
                    {
                        contractor = CreateContractor(),
                        startDate = GetDate(),
                        endDate = GetDate(),
                        contractNumber = "234567",
                        fundingType = new CorporateContract.fundingType
                        {
                            fundingTypeCode = "AAA",
                            fundingTypeName = "FTN"
                        },
                        contractType1 = "Contract Type",
                        contractStatus = CreateContractStatus(),
                        period = CreatePeriod(),
                        fundingStream = CreateFundingStream(),
                        contractAllocations = new List<CorporateContract.contractAllocationsContractAllocation>
                        {
                            new CorporateContract.contractAllocationsContractAllocation()
                            {
                                startDate = GetDate(),
                                endDate = GetDate(),
                                fundingStream = CreateFundingStream(),
                                period = CreatePeriod(),
                                contractAllocationNumber = "1",
                                contractDeliverables = new List<CorporateContract.contractDeliverablesTypeContractDeliverable>
                                {
                                    new CorporateContract.contractDeliverablesTypeContractDeliverable()
                                    {
                                        deliverable = new CorporateContract.deliverableType
                                        {
                                            deliverableCode = 1,
                                            fundingStreamCode = "X",
                                            businessCode = "2",
                                            deliverableName = "VV"
                                        },
                                        contractDeliverablePeriods = new List<CorporateContract.contractDeliverablePeriodsTypeContractDeliverablePeriod>
                                        {
                                            new CorporateContract.contractDeliverablePeriodsTypeContractDeliverablePeriod()
                                            {
                                                period = 1,
                                                plannedValue = 100
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            };

            return corporateContract;
        }

        private CorporateContract.contractStatusType CreateContractStatus()
        {
            return new CorporateContract.contractStatusType
            {
                parentStatus = CorporateSchema.contractStatusTypeParentStatus.Draft.ToString(),
                status = CorporateSchema.contractStatusTypeStatus.Draft.ToString()
            };
        }

        private CorporateContract.Contractor CreateContractor()
        {
            return new CorporateContract.Contractor
            {
                ukprn = 12345678,
                organisationAddressIdentifier = 12345678,
                organisationIdentifier = "121212",
                legalName = "TEST"
            };
        }

        private DateTime GetDate()
        {
            return DateTime.UtcNow.Date;
        }

        private CorporateContract.fundingStream CreateFundingStream()
        {
            return new CorporateContract.fundingStream
            {
                fundingStreamCode = "V",
                fundingStreamName = "YY",
                fundingTypeCode = "C",
                fundingStreamShortCode = "N"
            };
        }

        private CorporateContract.Period CreatePeriod()
        {
            return new CorporateContract.Period
            {
                period1 = "1516",
                startDate = GetDate(),
                endDate = GetDate()
            };
        }
    }
}