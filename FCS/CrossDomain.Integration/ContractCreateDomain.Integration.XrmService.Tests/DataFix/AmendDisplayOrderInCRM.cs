using Microsoft.VisualStudio.TestTools.UnitTesting;
using Microsoft.Xrm.Client;
using Microsoft.Xrm.Client.Services;
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Client;
using SFA.FCT.ContractCreateDomain.Implementation.Services;
using SFA.FCT.CrossDomain.Integration.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Caching;
using Castle.Windsor;
using ContractCreateDomain.Integration.XrmService.Tests.IntegrationTests;
using Castle.MicroKernel.Registration;


namespace ContractCreateDomain.Integration.XrmService.Tests.DataFix
{
    [TestClass]
    public class AmendDisplayOrderInCRM:IntegrationTestBase
    {
        private const string FscDeliverableDataCacheName = "fscDeliverableData";
        private const double CacheExpiration = 30;
        private readonly ObjectCache _cache = MemoryCache.Default;
        private IFundingStreamConfigService _fundingStreamConfigurationService;
        private readonly List<string> _fspAffectedList = new List<string> { "16-18APPS1516", "16-18APPS1617", "ALLF1617", "ASC1516", "ASTO1516", "OLASS1516", "OLASS1617" };
        private IWindsorContainer _container;

        private void BootstrapContainer()
        {
            _container = new WindsorContainer();

            _container.Register(
                Component.For<IFundingStreamConfigService>().ImplementedBy<FundingStreamConfigService>()
                );
        }

        [TestInitialize]
        public void TestInitialize()
        {
            BootstrapContainer();
            _fundingStreamConfigurationService = _container.Resolve<IFundingStreamConfigService>();
        }

        [TestMethod, TestCategory("DataFix_R16a")]
        public void ApplyDeliverableDisplayOrderDataFixInCRM()
        {

            //Establish the connection to CRM
            CrmConnection connection = new CrmConnection("CrmConnectionString");
            var service = new OrganizationService(connection);
            CrmOrganizationServiceContext _xrmContext = new CrmOrganizationServiceContext(service);
            int count = 0;

            //Loop through each listed FSP
            foreach (string _fspAffected in _fspAffectedList) { 
                string fundingStreamPeriodCode = _fspAffected;
                // Invoke the FSC web service to retrieve the deliverable structure configuration data
                // (Pass in the funding stream period data for this contract)
                FSCDeliverableStructureDefinitionResponse deliverableStructure = GetDeliverableStructure(fundingStreamPeriodCode);

                List<Entity> allocations = GetAllocationRecords(_xrmContext, fundingStreamPeriodCode);
                foreach (Entity allocation in allocations)
                {

                    List<Entity> relateddeliverables = GetRelatedDeliverables(_xrmContext, allocation);
                    count += relateddeliverables.Count;

                    foreach (Entity deliverable in relateddeliverables)
                    {
                        var ds = deliverableStructure.DeliverableStructureList.FirstOrDefault(m => m.DeliverableCode == int.Parse((string)deliverable["sfa_deliverablecode"]));

                        if (ds != null)
                        {
                            int? currDisplayOrder = (int?)deliverable.GetAttributeValue("sfa_displayorder");
                            int? paasDisplayOrder = int.Parse(ds.Settings.First(s => s.SettingCode == "displayorder").SettingValue);

                            if (currDisplayOrder != paasDisplayOrder)
                            {                               
                                Entity deliverableToUpdate = new Entity("sfa_contractdeliverable");
                                deliverableToUpdate.Id = deliverable.Id;
                                deliverableToUpdate.Attributes["sfa_displayorder"] = paasDisplayOrder;
                                service.Update(deliverableToUpdate);
                            }
                        
                        }
                    }
                }
                
            }
        }


        static List<Entity> GetAllocationRecords(CrmOrganizationServiceContext xrmContext, string _fspAffected)
        {
            
            List<Entity> allocations = (from a in xrmContext.CreateQuery("sfa_contractallocation")
                                        join f in xrmContext.CreateQuery("sfa_fundingstreamperiod")
                                          on a["sfa_fundingstreamperiodid"] equals f["sfa_fundingstreamperiodid"]
                                        where (string)f["sfa_fundingstreamperiodcode"] == _fspAffected
                                        select a).ToList();         

            return allocations;

        }

        static List<Entity> GetRelatedDeliverables(CrmOrganizationServiceContext xrmContext, Entity allocation)
        {
            
            List<Entity> deliverables = (from d in xrmContext.CreateQuery("sfa_contractdeliverable")
                                         where (Guid)d["sfa_contractallocationid"] == allocation.Id
                                         select d).ToList();

            return deliverables;

        }

        private FSCDeliverableStructureDefinitionResponse GetDeliverableStructure(string fundingStreamPeriodCode)
        {

            var cacheData = GetCacheData();

            FSCDeliverableStructureDefinitionResponse deliverableStructure;
            if (!cacheData.ContainsKey(fundingStreamPeriodCode))
            {
                // Get Full structure
               deliverableStructure = 
                    _fundingStreamConfigurationService.GetFullDeliverableStructure(fundingStreamPeriodCode);

                cacheData.Add(fundingStreamPeriodCode, deliverableStructure);
                _cache.Set(
                    FscDeliverableDataCacheName,
                    cacheData,
                    new CacheItemPolicy
                    {
                        AbsoluteExpiration = DateTimeOffset.Now.AddMinutes(CacheExpiration)
                    });
            }
            else
            {
                deliverableStructure = cacheData.FirstOrDefault(d => d.Key == fundingStreamPeriodCode).Value;
            }

            return deliverableStructure;
        }

        private IDictionary<string, FSCDeliverableStructureDefinitionResponse> GetCacheData()
        {
            IDictionary<string, FSCDeliverableStructureDefinitionResponse> cacheData =
                _cache[FscDeliverableDataCacheName] as IDictionary<string, FSCDeliverableStructureDefinitionResponse>;

            if (cacheData == null)
            {
                cacheData = new Dictionary<string, FSCDeliverableStructureDefinitionResponse>();
            }

            return cacheData;
        }
    }
}
