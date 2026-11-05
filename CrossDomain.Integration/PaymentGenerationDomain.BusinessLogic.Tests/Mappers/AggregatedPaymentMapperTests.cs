namespace PaymentGenerationDomain.BusinessLogic.Tests.Mappers
{
    using System;
    using System.Collections.Generic;
    using BusinessLogic.Mappers;
    using Integration.DataStore.Model;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class AggregatedPaymentMapperTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void MapDbEntitiesToAggregatedPaymentCorporateSchema_ReturnsEmptyListWhenNoAggregationsExist()
        {
            var mapper = new AggregatedPaymentMapper();

            var allocations = mapper.MapDbEntitiesToAggregatedPaymentCorporateSchema(
                new List<SubnominalAggregation>(),
                ConnectionInfo.CreateDefault());

            Assert.AreEqual(0, allocations.Count);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MapAggregatedPaymentCorporateSchemaEntityToDbEntities_ShouldMapPaymentAggregationSchema_To_SubnominalAggregationDbEntities()
        {
            //Arrange
            Allocation subnominalAggregationInCorporateSchema = new Allocation
            {
                AllocationNumber = "AllocationNumber1",
                VersionNumber = 2,
                FundingStreamPeriodCode = "FundingStreamPeriod1",
                AllocationPeriods = new List<AllocationPeriod>
                {
                    new AllocationPeriod
                    {
                        PeriodTypeCode = AllocationPeriodPeriodTypeCode.CM,
                        Period = "Period1",
                        Aggregations = new List<Aggregation>
                        {
                            new Aggregation
                            {
                                SubnominalCode = "Subnominal1",
                                PaymentType = AggregationPaymentType.CAPPING,              
                                AggregatedValue = 60.50m,
                                PostedFlag = true,
                                DeliverableDetails = new List<DeliverableDetail>
                                {
                                    new DeliverableDetail
                                    {
                                        DeliverableCode = 1,
                                        DeliverableValue = 10.10m
                                    },
                                    new DeliverableDetail
                                    {
                                        DeliverableCode = 2,
                                        DeliverableValue = 20.25m
                                    },
                                    new DeliverableDetail
                                    {
                                        DeliverableCode = 3,
                                        DeliverableValue = 30.15m
                                    }
                                }
                            },
                            new Aggregation
                            {
                                SubnominalCode = "Subnominal2",
                                PaymentType = AggregationPaymentType.PROFILE,              
                                AggregatedValue = 80.25m,
                                PostedFlag = true,
                                DeliverableDetails = new List<DeliverableDetail>
                                {
                                    new DeliverableDetail
                                    {
                                        DeliverableCode = 1,
                                        DeliverableValue = 40.25m
                                    },
                                    new DeliverableDetail
                                    {
                                        DeliverableCode = 2,
                                        DeliverableValue = 10.00m
                                    },
                                    new DeliverableDetail
                                    {
                                        DeliverableCode = 3,
                                        DeliverableValue = 30.00m
                                    }
                                }
                            }
                        }
                    },
                    new AllocationPeriod
                    {
                        PeriodTypeCode = AllocationPeriodPeriodTypeCode.CM,
                        Period = "Period2",
                        Aggregations = new List<Aggregation>
                        {
                            new Aggregation
                            {
                                SubnominalCode = "Subnominal3",
                                PaymentType= AggregationPaymentType.RECONCILIATION,              
                                AggregatedValue = 30.50m,
                                PostedFlag = true,
                                DeliverableDetails = new List<DeliverableDetail>
                                {
                                    new DeliverableDetail
                                    {
                                        DeliverableCode = 1,
                                        DeliverableValue = 15.10m
                                    },
                                    new DeliverableDetail
                                    {
                                        DeliverableCode = 2,
                                        DeliverableValue = 10.25m
                                    },
                                    new DeliverableDetail
                                    {
                                        DeliverableCode = 3,
                                        DeliverableValue = 5.15m
                                    }
                                }
                            },
                            new Aggregation
                            {
                                SubnominalCode = "Subnominal4",
                                PaymentType = AggregationPaymentType.RECONCILIATION ,              
                                AggregatedValue = 36.25m,
                                PostedFlag = true,
                                DeliverableDetails = new List<DeliverableDetail>
                                {
                                    new DeliverableDetail
                                    {
                                        DeliverableCode = 1,
                                        DeliverableValue = 5.25m
                                    },
                                    new DeliverableDetail
                                    {
                                        DeliverableCode = 2,
                                        DeliverableValue = 1.00m
                                    },
                                    new DeliverableDetail
                                    {
                                        DeliverableCode = 3,
                                        DeliverableValue = 30.00m
                                    }
                                }
                            }
                        }
                    }
                },
                Organisation = new Organisation
                {
                    MainOrganisationIdentifier = "ORG0000001",
                    AlternativeOrganisationIdentifiers = new List<OrgainsationIdentifier>
                    {
                        new OrgainsationIdentifier
                        {
                            OrganisationId= "123456",
                            OrganisationIdentifierName =  OrgainsationIdentifierOrganisationIdentifierName.UKPROVIDERREFERENCENUMBER
                        }
                    }
                }
            };

            //Act
            IAggregatedPaymentMapper aggregatedPaymentMapper = new AggregatedPaymentMapper();
            List<SubnominalAggregation> subnominalAggregations = aggregatedPaymentMapper.MapAggregatedPaymentCorporateSchemaToDbEntities(subnominalAggregationInCorporateSchema);

            //Assert
            Assert.IsTrue(subnominalAggregations.Count == 4, "The mapper did not create the correct number of aggregations");

            Assert.IsTrue(subnominalAggregations[0].AllocationNumber == "AllocationNumber1", "#1 - The allocation number was not mapped");
            Assert.AreEqual(2, subnominalAggregations[0].AllocationVersionNumber, "#1 - The allocation version number was not mapped");
            Assert.IsTrue(subnominalAggregations[0].FundingStreamPeriodCode == "FundingStreamPeriod1", "#1 - The funding stream period code was not mapped");
            Assert.IsTrue(subnominalAggregations[0].Period == "Period1", "#1 - The period was not mapped");
            Assert.IsTrue(subnominalAggregations[0].PeriodTypeCode == "CM", "#1 - The period type code was not mapped");
            Assert.IsTrue(subnominalAggregations[0].SubnominalCode == "Subnominal1", "#1 - The subnominal code was not mapped");
            Assert.IsTrue(subnominalAggregations[0].PaymentType == Enum.GetName(typeof(AggregationPaymentType), AggregationPaymentType.CAPPING), "#1 - The subnominal type was not mapped");
            Assert.IsTrue(subnominalAggregations[0].AggregatedValue == 60.50m, "#1 - The aggregated value was not mapped");
            Assert.IsTrue(subnominalAggregations[0].OrganisationId == "ORG0000001", "#1 - The organisation Id was not mapped");
            Assert.IsTrue(subnominalAggregations[0].Ukprn == 123456, "#1 - The Ukprn was not mapped");

            Assert.IsTrue(subnominalAggregations[1].AllocationNumber == "AllocationNumber1", "#2 - The allocation number was not mapped");
            Assert.AreEqual(2, subnominalAggregations[1].AllocationVersionNumber, "#2 - The allocation version number was not mapped");
            Assert.IsTrue(subnominalAggregations[1].FundingStreamPeriodCode == "FundingStreamPeriod1", "#2 - The funding stream period code was not mapped");
            Assert.IsTrue(subnominalAggregations[1].Period == "Period1", "#2 - The period was not mapped");
            Assert.IsTrue(subnominalAggregations[1].PeriodTypeCode == "CM", "#2 - The period type code was not mapped");
            Assert.IsTrue(subnominalAggregations[1].SubnominalCode == "Subnominal2", "#2 - The subnominal code was not mapped");
            Assert.IsTrue(subnominalAggregations[1].PaymentType == Enum.GetName(typeof(AggregationPaymentType), AggregationPaymentType.PROFILE), "#2 - The subnominal type was not mapped");
            Assert.IsTrue(subnominalAggregations[1].AggregatedValue == 80.25m, "#2 - The aggregated value was not mapped");
            Assert.IsTrue(subnominalAggregations[1].OrganisationId == "ORG0000001", "#2 - The organisation Id was not mapped");
            Assert.IsTrue(subnominalAggregations[1].Ukprn == 123456, "#2 - The Ukprn was not mapped");

            Assert.IsTrue(subnominalAggregations[2].AllocationNumber == "AllocationNumber1", "#3 - The allocation number was not mapped");
            Assert.AreEqual(2, subnominalAggregations[2].AllocationVersionNumber, "#3 - The allocation version number was not mapped");
            Assert.IsTrue(subnominalAggregations[2].FundingStreamPeriodCode == "FundingStreamPeriod1", "#3 - The funding stream period code was not mapped");
            Assert.IsTrue(subnominalAggregations[2].Period == "Period2", "#3 - The period was not mapped");
            Assert.IsTrue(subnominalAggregations[2].PeriodTypeCode == "CM", "#3 - The period type code was not mapped");
            Assert.IsTrue(subnominalAggregations[2].SubnominalCode == "Subnominal3", "#3 - The subnominal code was not mapped");
            Assert.IsTrue(subnominalAggregations[2].PaymentType == Enum.GetName(typeof(AggregationPaymentType), AggregationPaymentType.RECONCILIATION), "#3 - The subnominal type was not mapped");
            Assert.IsTrue(subnominalAggregations[2].AggregatedValue == 30.50m, "#3 - The aggregated value was not mapped");
            Assert.IsTrue(subnominalAggregations[2].OrganisationId == "ORG0000001", "#3 - The organisation Id was not mapped");
            Assert.IsTrue(subnominalAggregations[2].Ukprn == 123456, "#3 - The Ukprn was not mapped");

            Assert.IsTrue(subnominalAggregations[3].AllocationNumber == "AllocationNumber1", "#4 - The allocation number was not mapped");
            Assert.AreEqual(2, subnominalAggregations[2].AllocationVersionNumber, "#4 - The allocation version number was not mapped");
            Assert.IsTrue(subnominalAggregations[3].FundingStreamPeriodCode == "FundingStreamPeriod1", "#4 - The funding stream period code was not mapped");
            Assert.IsTrue(subnominalAggregations[3].Period == "Period2", "#4 - The period was not mapped");
            Assert.IsTrue(subnominalAggregations[3].PeriodTypeCode == "CM", "#4 - The period type code was not mapped");
            Assert.IsTrue(subnominalAggregations[3].SubnominalCode == "Subnominal4", "#4 - The subnominal code was not mapped");
            Assert.IsTrue(subnominalAggregations[3].PaymentType == Enum.GetName(typeof(AggregationPaymentType), AggregationPaymentType.RECONCILIATION), "#4 - The subnominal type was not mapped");
            Assert.IsTrue(subnominalAggregations[3].AggregatedValue == 36.25m, "#4 - The aggregated value was not mapped");
            Assert.IsTrue(subnominalAggregations[3].OrganisationId == "ORG0000001", "#4 - The organisation Id was not mapped");
            Assert.IsTrue(subnominalAggregations[3].Ukprn == 123456, "#4 - The Ukprn was not mapped");

        }

        private static List<Allocation> LoadExpectedData()
        {
            return new List<Allocation>()
            { new Allocation()
            {
                AllocationNumber = "1234",
                VersionNumber = 1,
                FundingStreamPeriodCode = "1234",
                Organisation = new Organisation{
                    MainOrganisationIdentifier = "1234",AlternativeOrganisationIdentifiers = new List<OrgainsationIdentifier>()
                    {
                        new OrgainsationIdentifier(){
                            OrganisationId = "1234",
                            OrganisationIdentifierName = OrgainsationIdentifierOrganisationIdentifierName.UKPROVIDERREFERENCENUMBER
                        }
                    }
                },
                AllocationPeriods = new List<AllocationPeriod>()
                {
                    new AllocationPeriod()
                    {
                        Period = "Period0",
                        PeriodTypeCode = AllocationPeriodPeriodTypeCode.AP,
                        Aggregations = new List<Aggregation>()
                        {
                            NewAggregation(2,"1")   
                        }
                    },
                    new AllocationPeriod()
                    {
                        Period = "Period1",
                        PeriodTypeCode = AllocationPeriodPeriodTypeCode.AP,
                        Aggregations = new List<Aggregation>
                        {
                            NewAggregation(2,"1"),
                            NewAggregation(2,"2")   
                        }
                    },
                    new AllocationPeriod()
                    {
                        Period = "Period2",
                        PeriodTypeCode = AllocationPeriodPeriodTypeCode.AP,
                        Aggregations = new List<Aggregation>
                        {
                            NewAggregation(2,"1"),
                            NewAggregation(2,"2")   
                        }
                    }
                        
                }
            },
                new Allocation()
                {
                    AllocationNumber = "1235",
                    VersionNumber = 1,
                    FundingStreamPeriodCode = "1235",
                    Organisation = new Organisation{
                        MainOrganisationIdentifier = "1234",AlternativeOrganisationIdentifiers = new List<OrgainsationIdentifier>()
                        {
                            new OrgainsationIdentifier(){
                                OrganisationId = "1234",
                                OrganisationIdentifierName = OrgainsationIdentifierOrganisationIdentifierName.UKPROVIDERREFERENCENUMBER
                            }
                        }
                    },
                    AllocationPeriods = new List<AllocationPeriod>()
                    {
                        new AllocationPeriod()
                        {
                            Period = "Period0",
                            PeriodTypeCode = AllocationPeriodPeriodTypeCode.AP,
                            Aggregations = new List<Aggregation>
                            {
                                NewAggregation(2,"1"),
                                NewAggregation(2,"2")   
                            }
                        }
                        
                    }
                }
            };
        }

        private static Aggregation NewAggregation(decimal aValue, string subCode)
        {
            return new Aggregation()
            {
                AggregatedValue = aValue,
                PaymentType = AggregationPaymentType.PROFILE,
                SubnominalCode = subCode
            };
        }
    }
}
