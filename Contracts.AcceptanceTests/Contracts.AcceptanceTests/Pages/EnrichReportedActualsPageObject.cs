namespace SFA.FCT.Contracts.AcceptanceTests.Pages
{
    using System;
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Linq;
    using System.Threading.Tasks;
    using AllocationDeliveryDomain.Common.DataStore;
    using AllocationDeliveryDomain.Common.DataStore.Model;
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Infrastructure.Services;
    using Microsoft.Xrm.Sdk;
    using XrmTestModel;
    using XrmTestModel.XrmObjects;
    using NUnit.Framework.Legacy;

    public class EnrichReportedActualsPageObject
    {
        private readonly IWindsorContainer _container;
        private readonly List<XrmOrganisation> _orgs = new List<XrmOrganisation>();
        private readonly List<XrmContract> _contracts = new List<XrmContract>();
        private const int WaitTillTableStorePopulatedInDbIntervalSeconds = 60;
        private const int SleepIntervalSeconds = 2;

        public int ExpectedDataStoreRowCount { get; set; }

        public List<AllocationDeliverablePeriodActualAudit> AllocationDeliverablePeriodActualAuditStored { get; set; }

        public EnrichReportedActualsPageObject()
        {
            _container = CreateContainer();
        }

        public void StoreAllocationDeliverablePeriods(IEnumerable<AllocationDeliverablePeriod> allocationDeliverablePeriods)
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                allocationDeliverablePeriods.ToList().ForEach(adp => context.AllocationDeliverablePeriods.Add(adp));
                context.SaveChanges();
            }
        }

        public void ClearAllocationDeliverablePeriods(IEnumerable<AllocationDeliverablePeriod> allocationDeliverablePeriods)
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                allocationDeliverablePeriods.ToList().ForEach(adp =>
                {
                    var allocationDeliverablePeriodToDelete =
                        context.AllocationDeliverablePeriods.FirstOrDefault(
                            x =>
                                x.OrganisationId == adp.OrganisationId &&
                                x.FundingStreamPeriodCode == adp.FundingStreamPeriodCode && x.UopCode == adp.UopCode &&
                                x.DeliverableCode == adp.DeliverableCode && x.Period == adp.Period);

                    if (allocationDeliverablePeriodToDelete != null)
                    {
                    context.AllocationDeliverablePeriods.Remove(allocationDeliverablePeriodToDelete);
                    }
                });
                context.SaveChanges(); ;
            }
        }

        public void RemoveDataInCrm()
        {
            _contracts.ForEach(c => c.Delete());
            _orgs.ForEach(o => o.Delete());
        }

        public void CreateDataInCrm(string contractNumber, string ukprn, string allocationRef)
        {
            var org = _container.Resolve<XrmOrganisation>();
            org.Ukprn = ukprn;

            org.OrganisationName = this.GetType() + " " + ukprn;
            org.Save();
            _orgs.Add(org);

            var caseload = _container.Resolve<XrmCaseload>();
            caseload.Organisation = org;
            caseload.Save();

            var contract = GetCrmContract("Master-" + contractNumber, contractNumber, ukprn, allocationRef);

            contract.Save();
            _contracts.Add(contract);
        }

        private XrmContract GetCrmContract(string masterContractNumber, string contractNumber, string ukprn, string allocationRef)
        {
            var mastercontract = _container.Resolve<XrmContract>();

            mastercontract.Ukprn = ukprn;
            mastercontract.ContractNumber = masterContractNumber;
            mastercontract.Description = "Test Description";
            mastercontract.ContractType = "Contract for Services";
            mastercontract.FundingType = "Apprenticeship Grant for Employers";
            mastercontract.ParentContractNumber = null;
            mastercontract.SubVersion = 1;
            mastercontract.Version = 1;
            
            var contract = _container.Resolve<XrmContract>();

            contract.Ukprn = ukprn;
            contract.ContractNumber = contractNumber;
            contract.Description = "Test Description";
            contract.ContractType = "Contract for Services";
            contract.FundingType = "Apprenticeship Grant for Employers";
            contract.ParentContractNumber = null;
            contract.SubVersion = 1;
            contract.Version = 1;
            contract.LastApprovedVersion = true;

            var allocation1 = _container.Resolve<XrmContractAllocation>();

            allocation1.ContractAllocationRef = allocationRef;
            allocation1.FundingStreamPeriod =
                _container.Resolve<XrmFundingStreamPeriod>().Get("ASC1516") as XrmFundingStreamPeriod;
            allocation1.Contract = contract;
            allocation1.ContractAllocationRef = allocationRef;
            allocation1.AllocationValue = 100;
            allocation1.FundingStream = "ASC";
            
            var deliverable1 = _container.Resolve<XrmContractDeliverable>();

            deliverable1.Contract = contract;
            deliverable1.Allocation = allocation1;
            deliverable1.DeliverableCode = "2";
            deliverable1.PlannedValue = 100;
            deliverable1.PlannedVolume = 100;
            deliverable1.ProfileDeliverable = "Aggregate";

            mastercontract.ChildContracts = new List<Contract> { contract };
            contract.Allocations = new List<ContractAllocation> { allocation1 };
            allocation1.Deliverables = new List<ContractDeliverable> { deliverable1 };
            deliverable1.Periods = GetDeliverablePeriods(deliverable1);

            return mastercontract;
        }

        private IEnumerable<ContractDeliverablePeriod> GetDeliverablePeriods(XrmContractDeliverable deliverable)
        {
            var deliverableperiod1 = _container.Resolve<XrmContractDeliverablePeriod>();

            deliverableperiod1.Deliverable = deliverable;
            deliverableperiod1.ActualValue = 0;
            deliverableperiod1.PeriodName = "Aug-2015";
            deliverableperiod1.PeriodNumber = 8;
            deliverableperiod1.Year = 2015;
            deliverableperiod1.PaymentPosted = false;

            var deliverableperiod2 = _container.Resolve<XrmContractDeliverablePeriod>();

            deliverableperiod2.Deliverable = deliverable;
            deliverableperiod2.ActualValue = 0;
            deliverableperiod2.PeriodName = "Sep-2015";
            deliverableperiod2.PeriodNumber = 9;
            deliverableperiod2.Year = 2015;
            deliverableperiod2.PaymentPosted = false;

            var deliverableperiod3 = _container.Resolve<XrmContractDeliverablePeriod>();

            deliverableperiod3.Deliverable = deliverable;
            deliverableperiod3.ActualValue = 0;
            deliverableperiod3.PeriodName = "Oct-2015";
            deliverableperiod3.PeriodNumber = 10;
            deliverableperiod3.Year = 2015;
            deliverableperiod3.PaymentPosted = false;

            var deliverableperiod4 = _container.Resolve<XrmContractDeliverablePeriod>();

            deliverableperiod4.Deliverable = deliverable;
            deliverableperiod4.ActualValue = 0;
            deliverableperiod4.PeriodName = "Nov-2015";
            deliverableperiod4.PeriodNumber = 11;
            deliverableperiod4.Year = 2015;
            deliverableperiod4.PaymentPosted = false;

            var deliverableperiod5 = _container.Resolve<XrmContractDeliverablePeriod>();

            deliverableperiod5.Deliverable = deliverable;
            deliverableperiod5.ActualValue = 0;
            deliverableperiod5.PeriodName = "Dec-2015";
            deliverableperiod5.PeriodNumber = 12;
            deliverableperiod5.Year = 2015;
            deliverableperiod5.PaymentPosted = false;

            var deliverableperiod6 = _container.Resolve<XrmContractDeliverablePeriod>();

            deliverableperiod6.Deliverable = deliverable;
            deliverableperiod6.ActualValue = 0;
            deliverableperiod6.PeriodName = "Jan-2016";
            deliverableperiod6.PeriodNumber = 1;
            deliverableperiod6.Year = 2016;
            deliverableperiod6.PaymentPosted = false;

            var deliverableperiod7 = _container.Resolve<XrmContractDeliverablePeriod>();

            deliverableperiod7.Deliverable = deliverable;
            deliverableperiod7.ActualValue = 0;
            deliverableperiod7.PeriodName = "Feb-2016";
            deliverableperiod7.PeriodNumber = 2;
            deliverableperiod7.Year = 2016;
            deliverableperiod7.PaymentPosted = false;

            var deliverableperiod8 = _container.Resolve<XrmContractDeliverablePeriod>();

            deliverableperiod8.Deliverable = deliverable;
            deliverableperiod8.ActualValue = 0;
            deliverableperiod8.PeriodName = "Mar-2016";
            deliverableperiod8.PeriodNumber = 3;
            deliverableperiod8.Year = 2016;
            deliverableperiod8.PaymentPosted = false;

            var deliverableperiod9 = _container.Resolve<XrmContractDeliverablePeriod>();

            deliverableperiod9.Deliverable = deliverable;
            deliverableperiod9.ActualValue = 0;
            deliverableperiod9.PeriodName = "Apr-2016";
            deliverableperiod9.PeriodNumber = 4;
            deliverableperiod9.Year = 2016;
            deliverableperiod9.PaymentPosted = false;

            var deliverableperiod10 = _container.Resolve<XrmContractDeliverablePeriod>();

            deliverableperiod10.Deliverable = deliverable;
            deliverableperiod10.ActualValue = 0;
            deliverableperiod10.PeriodName = "May-2016";
            deliverableperiod10.PeriodNumber = 5;
            deliverableperiod10.Year = 2016;
            deliverableperiod10.PaymentPosted = false;

            var deliverableperiod11 = _container.Resolve<XrmContractDeliverablePeriod>();

            deliverableperiod11.Deliverable = deliverable;
            deliverableperiod11.ActualValue = 0;
            deliverableperiod11.PeriodName = "Jun-2016";
            deliverableperiod11.PeriodNumber = 6;
            deliverableperiod11.Year = 2016;
            deliverableperiod11.PaymentPosted = false;

            var deliverableperiod12 = _container.Resolve<XrmContractDeliverablePeriod>();

            deliverableperiod12.Deliverable = deliverable;
            deliverableperiod12.ActualValue = 0;
            deliverableperiod12.PeriodName = "Jul-2016";
            deliverableperiod12.PeriodNumber = 7;
            deliverableperiod12.Year = 2016;
            deliverableperiod12.PaymentPosted = false;

            var deliverablePeriods = new List<ContractDeliverablePeriod>
            {
                deliverableperiod1,
                deliverableperiod2,
                deliverableperiod3,
                deliverableperiod4,
                deliverableperiod5,
                deliverableperiod6,
                deliverableperiod7,
                deliverableperiod8,
                deliverableperiod9,
                deliverableperiod10,
                deliverableperiod11,
                deliverableperiod12
            };
            return deliverablePeriods;
        }

        public void ValidateAllocationDeliverablePeriodActualAudit(IEnumerable<AllocationDeliverablePeriodActualAudit> allocationDeliverablePeriodActualAudits)
        {
            var result = from t1 in AllocationDeliverablePeriodActualAuditStored
                         join t2 in allocationDeliverablePeriodActualAudits
                             on new
                             {
                                 t1.CollectionReturnPeriod,
                                 t1.Ukprn,
                                 t1.ContractNumber,
                                 t1.ContractVersion,
                                 t1.ContractSubVersion,
                                 t1.AllocationStartDate,
                                 t1.AllocationEndDate,
                                 t1.CollectionReturnCode,
                                 t1.OrganisationId,
                                 t1.PeriodTypeCode,
                                 t1.Period,
                                 t1.FundingStreamPeriodCode,
                                 t1.CollectionType,
                                 t1.ContractAllocationNumber,
                                 t1.UopCode,
                                 t1.DeliverableCode,
                                 t1.ActualVolume,
                                 t1.ActualValue,
                                 t1.ParentDeliverableCode
                             }
                         equals new
                         {
                             t2.CollectionReturnPeriod,
                             t2.Ukprn,
                             t2.ContractNumber,
                             t2.ContractVersion,
                             t2.ContractSubVersion,
                             t2.AllocationStartDate,
                             t2.AllocationEndDate,
                             t2.CollectionReturnCode,
                             t2.OrganisationId,
                             t2.PeriodTypeCode,
                             t2.Period,
                             t2.FundingStreamPeriodCode,
                             t2.CollectionType,
                             t2.ContractAllocationNumber,
                             t2.UopCode,
                             t2.DeliverableCode,
                             t2.ActualVolume,
                             t2.ActualValue,
                             t2.ParentDeliverableCode
                         }
                         select new
                         {
                             t1.CollectionReturnPeriod,
                             t1.Ukprn,
                             t1.ContractNumber,
                             t1.ContractVersion,
                             t1.ContractSubVersion,
                             t1.AllocationStartDate,
                             t1.AllocationEndDate,
                             t1.CollectionReturnCode,
                             t1.OrganisationId,
                             t1.PeriodTypeCode,
                             t1.Period,
                             t1.FundingStreamPeriodCode,
                             t1.CollectionType,
                             t1.ContractAllocationNumber,
                             t1.UopCode,
                             t1.DeliverableCode,
                             t1.ActualVolume,
                             t1.ActualValue,
                             t1.ParentDeliverableCode
                         };

            // assert both that the results are correct, and also that no other results were stored at the client
            ClassicAssert.That(result.Count(),NUnit.Framework.Is.EqualTo(allocationDeliverablePeriodActualAudits.Count()));

            ClassicAssert.That(AllocationDeliverablePeriodActualAuditStored.Count(),NUnit.Framework.Is.EqualTo(allocationDeliverablePeriodActualAudits.Count()));
        }

        public void WaitTillAllocationDeliverablePeriodActualAuditPopulated()
        {
            var contractNumber = _contracts.First().ChildContracts.First().ContractNumber;

            DateTime endTime = DateTime.UtcNow.AddSeconds(WaitTillTableStorePopulatedInDbIntervalSeconds);

            do
            {
                AllocationDeliverablePeriodActualAuditStored = GetDataAllocationDeliverablePeriodActualAuditStore(contractNumber);

                Task.Delay(TimeSpan.FromSeconds(SleepIntervalSeconds)).Wait();
            }
            while (AllocationDeliverablePeriodActualAuditStored.Count < ExpectedDataStoreRowCount && (DateTime.UtcNow < endTime));
        }

        private List<AllocationDeliverablePeriodActualAudit> GetDataAllocationDeliverablePeriodActualAuditStore(string contractNumber)
        {
            IMonitoringDeliverablesDbContext context = new MonitoringDeliverablesDbContext();
            return (from b in context.AllocationDeliverablePeriodActualAudits
                    where b.ContractNumber == contractNumber
                    select b).ToList(); //add condition based of required data
        }

        public void ClearAllocationDeliverablePeriodActualAudits(IEnumerable<AllocationDeliverablePeriodActualAudit> allocationDeliverablePeriodActualAudits)
        {
            // this currently ignores the passed in allocationDeliverablePeriodActualAudits
            // if this is changed to only delete allocationDeliverablePeriodActualAudits, then it will need to delete all if null is passed in

            IMonitoringDeliverablesDbContext context = new MonitoringDeliverablesDbContext();

            // better way??
            var actualAudits = context.AllocationDeliverablePeriodActualAudits as DbSet<AllocationDeliverablePeriodActualAudit>;
            actualAudits.RemoveRange(actualAudits);

            context.SaveChanges();
        }

        private static IWindsorContainer CreateContainer()
        {
            return new WindsorContainer().Install(new XrmServicesInstaller());
        }

        private class XrmServicesInstaller : IWindsorInstaller
        {
            public void Install(IWindsorContainer container, IConfigurationStore store)
            {
                container.Register(
                    Types.FromAssembly(typeof(IUseXrmService).Assembly).BasedOn<IUseXrmService>().LifestyleTransient(),
                    Component.For<IXrmServiceFactory>().ImplementedBy<CrmConnectionFactoryXrmServiceFactory>().LifeStyle.Transient);
            }
        }

        private class CrmConnectionFactoryXrmServiceFactory : IXrmServiceFactory
        {
            public IOrganizationService Create()
            {
                return CrmConnectionFactory.GetConnection();
            }

            public IOrganizationService Create(string userName)
            {
                return CrmConnectionFactory.GetConnectionForSpecificUser(userName);
            }
        }
    }
}
