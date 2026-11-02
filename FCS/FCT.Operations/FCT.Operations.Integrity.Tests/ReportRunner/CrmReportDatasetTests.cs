namespace FCT.Operations.Integrity.Tests.ReportRunner
{
    using System;
    using System.Configuration;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Client;
    using Microsoft.Xrm.Client.Services;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Query;
    using System.Collections.Generic;
    using SFA.FCS.Worker.Common.Crm;

    namespace CrossDomain.Integration.ReportRunnerEndpoint.Tests.Integration.CRM
    {
        [TestClass]
        public class CrmReportDatasetTests
        {
            private IOrganizationService service = null;
            private CrmOrganizationServiceContext xrmContext = null;
            private EntityReferenceCollection associatedSubnominals;
            private string providerName = "Report Testing Provider";
            private string UKPRN = "10099999";
            private string contractAllocationNumber = "16AP-565";
            private string subnominalFSP = "16-18APPS1516";
            private string subnominalFSPName = "16-18 Apprenticeships 15/16";
            private string subnominalPeriod = "Apr-13";

            [TestInitialize]
            public void Initialize()
            {
                service = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
                xrmContext = new CrmOrganizationServiceContext(service);
                CleanupTestData(xrmContext);
            }

            [TestMethod, TestCategory("IntegrationTest")]
            public void Report_DistinctPeriodsForCensus()
            {
                string CensusDatePicker = "2017-05-08";
                var distinctPeriods = GetDistinctPeriodsForCensus(CensusDatePicker);
                Assert.AreEqual(2, distinctPeriods.Entities.Count, "There are two Periods supposed to be extracted for this Census date");
                Assert.AreEqual("May-17", distinctPeriods.Entities.ToList().First().GetAttributeValue("sfa_period"), "The Query should return a period of May-17");
                Assert.AreEqual("Apr-17", distinctPeriods.Entities.ToList().Last().GetAttributeValue("sfa_period"), "The Query should return a period of Apr-17");
            }

            [TestMethod, TestCategory("IntegrationTest")]
            public void Report_CensusDateFilteredFSP()
            {
                string CensusDatePicker = "2016-03-17";
                string period = "Feb-16";
                var distinctFSPs = GetCensusDateFilteredFSP(CensusDatePicker, period);
                Assert.AreEqual(1, distinctFSPs.Entities.Count, "There is one FSP supposed to be extracted for this Census date and period of " + period);
                var FSPReference = (EntityReference)distinctFSPs.Entities.First().GetAttributeValue("sfa_fundingstreamperiod");
                var FSP = service.Retrieve("sfa_fundingstreamperiod", FSPReference.Id, new ColumnSet(true));
                Assert.AreEqual("AGE1516", FSP.GetAttributeValue("sfa_fundingstreamperiodcode"), "The Query should return a Funding Stream Period of AGE1516");
            }

            [TestMethod, TestCategory("IntegrationTest")]
            public void Report_SubnominalFSPFilteredData()
            {
                CreateTestData();
                var subnominalData = GetSubnominalFSPFilteredData(subnominalPeriod, subnominalFSP);
                var subData = subnominalData.Entities.First();
                Assert.AreEqual((decimal)300.00, (decimal)(((AliasedValue)subData["AV"]).Value), "Aggregate Value returned should be 300.00");
                Assert.AreEqual(229660000, ((OptionSetValue)(((AliasedValue)subData["PT"]).Value)).Value, "Payment type should be Profile Payment.");
                Assert.AreEqual(subnominalFSPName, (string)(((AliasedValue)subData["FSPName"]).Value), "Funding Stream Period Name incorrect");
            }

            [TestMethod, TestCategory("IntegrationTest")]
            public void Report_SubnominalUKPRNFilteredData()
            {
                CreateTestData();
                var subnominalData = GetSubnominalUKPRNFilteredData(subnominalPeriod, subnominalFSP);
                var subData = subnominalData.Entities.First();
                Assert.AreEqual((decimal)300.00, (decimal)(((AliasedValue)subData["AV"]).Value), "Aggregate Value returned should be 300.00");
                Assert.AreEqual(229660000, ((OptionSetValue)(((AliasedValue)subData["PT"]).Value)).Value, "Payment type should be Profile Payment.");
                Assert.AreEqual(UKPRN, (string)(((AliasedValue)subData["UKPRN"]).Value), "UKPRN incorrect");
            }

            private EntityCollection GetDistinctPeriodsForCensus(string CensusDatePicker)
            {
                var DistinctPeriodsForCensus =
                @"<fetch version='1.0' output-format='xml-platform' mapping='logical' distinct='true' >
				    <entity name='sfa_paymenttimetable' >
					    <attribute name='sfa_period' />
					    <order attribute='sfa_period' descending='true' />
					    <filter type='and' >
						    <condition attribute='sfa_censusenddate' operator='on' value='" + CensusDatePicker + @"' />
					    </filter>
				    </entity>
			    </fetch>";
                return service.RetrieveMultiple(new FetchExpression(DistinctPeriodsForCensus));
            }

            private EntityCollection GetCensusDateFilteredFSP(string CensusDatePicker, string DistinctPeriod)
            {
                var CensusDateFilteredFSPDataSet =
                @"<fetch version='1.0' output-format='xml-platform' mapping='logical' distinct='false'>
				    <entity name='sfa_paymenttimetable'>
					    <attribute name='sfa_fundingstreamperiod' />
					    <filter type='and'>
						    <condition attribute='statecode' operator='eq' value='0' />
						    <condition attribute='sfa_censusenddate' operator='on' value='" + CensusDatePicker + @"' />
						    <condition attribute='sfa_period' operator='eq' value='" + DistinctPeriod + @"' />
					    </filter>
				    </entity>
			    </fetch>";
                return service.RetrieveMultiple(new FetchExpression(CensusDateFilteredFSPDataSet));
            }
            private EntityCollection GetSubnominalFSPFilteredData(string DistinctPeriod, string CensusFilteredFSP)
            {
                var SubnominalFilteredDataSet =
                @"<fetch aggregate='true' >
                  <entity name='sfa_subnominalaggregation' >
                    <attribute name='sfa_aggregatedvalue' alias='AV' aggregate='sum' />
                    <attribute name='sfa_paymenttype' alias='PT' groupby='true' />
                    <attribute name='sfa_period' alias='PD' groupby='true' />
                    <attribute name='sfa_fundingstreamperiod' alias='FSP' groupby='true' />
                    <filter type='and' >
                      <condition attribute='sfa_period' operator='eq' value='" + DistinctPeriod + @"' />
                      <condition attribute='sfa_fundingstreamperiodname' operator='eq' value='" + CensusFilteredFSP + @"' />
                    </filter>
                    <link-entity name='sfa_fundingstreamperiod' from='sfa_fundingstreamperiodid' to='sfa_fundingstreamperiod' >
                        <attribute name='sfa_fundingstreamperiodname' alias = 'FSPName' groupby='true' />
                    </link-entity>   
                  </entity>
                </fetch>";
                return service.RetrieveMultiple(new FetchExpression(SubnominalFilteredDataSet));
            }
            private EntityCollection GetSubnominalUKPRNFilteredData(string DistinctPeriod, string CensusFilteredFSP)
            {
                var SubnominalFilteredDataSet =
                @"<fetch aggregate='true' >
                  <entity name='sfa_subnominalaggregation' >
                    <attribute name='sfa_aggregatedvalue' alias='AV' aggregate='sum' />
                    <attribute name='sfa_paymenttype' alias='PT' groupby='true' />
                    <attribute name='sfa_period' alias='PD' groupby='true' />
                    <attribute name='sfa_fundingstreamperiod' alias='FSP' groupby='true' />
                    <filter type='and' >
                      <condition attribute='sfa_period' operator='eq' value='" + DistinctPeriod + @"' />
                      <condition attribute='sfa_fundingstreamperiodname' operator='eq' value='" + CensusFilteredFSP + @"' />
                      <condition attribute='sfa_aggregatedvalue' operator='neq' value='0' />
                    </filter>
                    <link-entity name='sfa_fundingstreamperiod' from='sfa_fundingstreamperiodid' to='sfa_fundingstreamperiod' >
                        <attribute name='sfa_fundingstreamperiodname' alias = 'FSPName' groupby='true' />
                    </link-entity>
	                <link-entity name='account' from='accountid' to='sfa_provider' >
                      <attribute name='sfa_ukprn' alias='UKPRN' groupby='true' />
                      <attribute name='name' alias='ProviderName' groupby='true' />
                    </link-entity>
                  </entity>
                </fetch>";
                return service.RetrieveMultiple(new FetchExpression(SubnominalFilteredDataSet));
            }
            private IOrganizationService GetConnection()
            {
                var xrmConnection = CrmConnection.Parse(ConfigurationManager.ConnectionStrings["CrmConnectionString"].ConnectionString);
                return new OrganizationService(xrmConnection);
            }
            private void CreateTestData()
            {
                Guid contractid;
                Guid providerid;
                Guid allocid;
                providerid = CreateProvider(providerName, UKPRN);
                contractid = SaveContract(providerid, UKPRN);
                allocid = AssociateAllocation(contractid);
                associatedSubnominals = AssociateSubnominalsToAllocation(allocid, providerid);
            }
            private Guid CreateProvider(string providerName, string UKPRN)
            {
                Entity provider = new Entity("account");
                provider.Attributes["name"] = providerName;
                provider.Attributes["sfa_ukprn"] = UKPRN;
                Guid providerid = service.Create(provider);
                return providerid;
            }
            private Guid SaveContract(Guid providerid, string UKPRN)
            {
                Entity contract = new Entity("sfa_contract");
                contract.Attributes["sfa_number"] = "MAIN-" + UKPRN;
                contract.Attributes["sfa_version"] = 1;
                contract.Attributes["sfa_ukprn"] = UKPRN;
                contract.Attributes["sfa_lastapprovedversion"] = true;
                contract.Attributes["sfa_providername"] = new EntityReference("account", providerid);
                contract.Attributes["sfa_contractstatus"] = new OptionSetValue(229660000);
                contract.Attributes["sfa_contractvalue"] = new Money(100000);
                contract.Attributes["sfa_enddate"] = DateTime.Now;
                contract.Attributes["sfa_startdate"] = DateTime.Now;
                contract.Attributes["sfa_hierarchytype"] = new OptionSetValue(229660000);
                Guid contractid = service.Create(contract);
                return contractid;
            }
            private Guid AssociateAllocation(Guid contractId)
            {
                Entity fundingStream = (from fs in xrmContext.CreateQuery("sfa_fundingstreamperiod")
                                        where (string)fs["sfa_fundingstreamperiodcode"] == subnominalFSP
                                        select fs).FirstOrDefault();
                Entity allocation = new Entity("sfa_contractallocation");
                allocation.Attributes["sfa_contractallocationnumber"] = contractAllocationNumber;
                allocation.Attributes["sfa_fundingstreamperiodid"] = new EntityReference("sfa_fundingstreamperiod", fundingStream.Id); ;
                allocation.Attributes["sfa_contractid"] = new EntityReference("sfa_contract", contractId);
                Guid allocId = service.Create(allocation);
                return allocId;
            }
            private EntityReferenceCollection AssociateSubnominalsToAllocation(Guid allocId, Guid providerid)
            {
                Entity fundingStream = (from fs in xrmContext.CreateQuery("sfa_fundingstreamperiod")
                                        where (string)fs["sfa_fundingstreamperiodcode"] == subnominalFSP
                                        select fs).FirstOrDefault();
                Entity subnomAgg1 = new Entity("sfa_subnominalaggregation");
                subnomAgg1.Attributes["sfa_name"] = "2201000";
                subnomAgg1.Attributes["sfa_subnominalcode"] = "2201000";
                subnomAgg1.Attributes["sfa_aggregatedvalue"] = (decimal)100;
                subnomAgg1.Attributes["sfa_paymenttype"] = new OptionSetValue(229660000);
                subnomAgg1.Attributes["sfa_period"] = subnominalPeriod;
                subnomAgg1.Attributes["sfa_periodtypecode"] = "CM";
                subnomAgg1.Attributes["sfa_subnominalaggregatekey"] = "2201000_" + contractAllocationNumber + "_" + subnominalPeriod;
                subnomAgg1.Attributes["sfa_fundingstreamperiod"] = fundingStream.ToEntityReference();
                subnomAgg1.Attributes["sfa_provider"] = new EntityReference("account", providerid);
                Guid subnomId1 = service.Create(subnomAgg1);
                Entity subnomAgg2 = new Entity("sfa_subnominalaggregation");
                subnomAgg2.Attributes["sfa_name"] = "2201000";
                subnomAgg2.Attributes["sfa_subnominalcode"] = "2201000";
                subnomAgg2.Attributes["sfa_aggregatedvalue"] = (decimal)200;
                subnomAgg2.Attributes["sfa_paymenttype"] = new OptionSetValue(229660000);
                subnomAgg2.Attributes["sfa_period"] = subnominalPeriod;
                subnomAgg2.Attributes["sfa_periodtypecode"] = "CM";
                subnomAgg2.Attributes["sfa_subnominalaggregatekey"] = "2201000_" + contractAllocationNumber + "_" + subnominalPeriod;
                subnomAgg2.Attributes["sfa_fundingstreamperiod"] = fundingStream.ToEntityReference();
                subnomAgg2.Attributes["sfa_provider"] = new EntityReference("account", providerid);
                Guid subnomId2 = service.Create(subnomAgg2);
                EntityReferenceCollection relatedEntities = new EntityReferenceCollection();
                relatedEntities.Add(new EntityReference("sfa_subnominalaggregation", subnomId1));
                relatedEntities.Add(new EntityReference("sfa_subnominalaggregation", subnomId2));
                Relationship relationship = new Relationship("sfa_sfa_subnominalaggregation_sfa_contractall");
                //Associate the contract 
                service.Associate("sfa_contractallocation", allocId, relationship, relatedEntities);
                return relatedEntities;
            }
            private void CleanupTestData(CrmOrganizationServiceContext xrmContext)
            {
                List<Entity> contracts = (from a in xrmContext.CreateQuery("sfa_contract")
                                          where (string)a["sfa_number"] == "MAIN-" + UKPRN
                                          select a).ToList();
                if (contracts.Count > 0)
                {
                    foreach (var c in contracts)
                    {
                        service.Delete("sfa_contract", c.Id);
                    }
                }
                List<Entity> subnominals = (from s in xrmContext.CreateQuery("sfa_subnominalaggregation")
                                            where (string)s["sfa_period"] == subnominalPeriod
                                            select s).ToList();
                if (subnominals.Count > 0)
                {
                    foreach (var s in subnominals)
                    {
                        service.Delete("sfa_subnominalaggregation", s.Id);
                    }
                }
                List<Entity> providers = (from p in xrmContext.CreateQuery("account")
                                          where (string)p["sfa_ukprn"] == UKPRN
                                          select p).ToList();
                if (providers.Count > 0)
                {
                    foreach (var p in providers)
                    {
                        service.Delete("account", p.Id);
                    }
                }
            }
        }
    }
}