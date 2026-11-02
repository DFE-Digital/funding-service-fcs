namespace AllocationsEventsLoader.Loaders
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.Entity;
    using System.Linq;
    using ADMonitoringDomain.DataStore;
    using ADMonitoringDomain.Endpoint;
    using ADMonitoringDomain.Endpoint.BusinessLogic;
    using Castle.Core.Internal;
    using Helpers;
    using Microsoft.Xrm.Client;
    using Microsoft.Xrm.Client.Services;
    using Moq;
    using NServiceBus;
    using SFA.FCT.AllocationDelivery.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.ContractCreateDomain.Implementation;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.DeliveryAllocation;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.Framework.Logging.NullObjects;
    using SFA.FCT.PaymentManagementDomain.BusinessLogic;
    using SFA.FCT.PaymentManagementDomain.Integration.PaymentAggregation.Handlers;
    using SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Handlers;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
    using SFA.FCT.PMD.PaymentManagment.DataStore;
    using SFA.FCT.PMD.PaymentManagment.DataStore.Model;
    using RulesEngine = SFA.FCT.PaymentManagementDomain.Integration.RulesEngine.RulesEngine;
    using PaymentGenerationDomain.BusinessLogic;
    using PaymentGenerationDomain.Integration.DataStore;

    public abstract class ContractAllocationApprovedFeedLoader
    {
        protected readonly IMonitoringDeliverablesDbContext _monitoringDeliverablesDbContext;
        private readonly IList<PaymentScheduleEvent> _paymentScheduleEvents = new List<PaymentScheduleEvent>(); 
        private readonly IList<PaymentAggregatedEvent> _paymentAggregatedEvents = new List<PaymentAggregatedEvent>();
        private readonly Mock<ILogger> _loggerMock = new Mock<ILogger>();
        private static readonly IPaymentManagementPolicyContext PaymentManagementPolicyContext = new PaymentManagementPolicyContext();
        private static readonly IPaymentSchedulePolicyContext PaymentSchedulePolicyContext = new PaymentSchedulePolicyContext();
        private static readonly IAllocationDeliveryDbContext AllocationDeliveryDbContext = new AllocationDeliveryDbContext();
        private static readonly IAllocationDeliveryMonitoringDbContext AllocationDeliveryMonitoringContext = new AllocationDeliveryMonitoringDbContext();
        private ContractAllocationApprovedHandler _contractAllocationApprovedHandler = null;
        private LookupManager _lookupManager;
        private PaymentManager _paymentManager;
        private int _numAllocationsStartedProcessing = 0;
        private int _totalNumAllocations;
        private IDictionary<string, DateTime?> _contractApprovedDates = new Dictionary<string, DateTime?>(); 

        protected ContractAllocationApprovedFeedLoader(IMonitoringDeliverablesDbContext monitoringDeliverablesDbContext)
        {
            _monitoringDeliverablesDbContext = monitoringDeliverablesDbContext;
        }

        public void LoadFeed()
        {
            Console.WriteLine("Time started - {0}", DateTime.Now.ToLongTimeString());

            IEnumerable<allocationType> allocations = GetAllocationsUsingParallel();
            Console.WriteLine("Got all of the data to process");
            _totalNumAllocations = allocations.Count();
            allocations.ForEach(ProcessAllocation);
            Console.WriteLine("Time finished - {0}", DateTime.Now.ToLongTimeString());
        }

        private IList<allocationType> GetAllocationsUsingParallel()
        {
            List<allocationType> allAllocations = new List<allocationType>();
            IList<System.Threading.Tasks.Task> taskList = new List<System.Threading.Tasks.Task>();
            foreach (var f in PaymentManagementPolicyContext.PolicyFundingStreamPeriods)
            { 
                taskList.Add(System.Threading.Tasks.Task.Run(() =>
                allAllocations.AddRange(GetAllocations(f.FundingStreamPeriod))));
            }

            System.Threading.Tasks.Task.WaitAll(taskList.ToArray());

            return allAllocations;
        }

        protected abstract IEnumerable<allocationType> GetAllocations(string fundingStreamPeriod);

        private void ProcessAllocation(allocationType allocation)
        {
            Console.WriteLine("Processing Allocation {0} - this is the {1} of {2}", allocation.contractAllocationNumber, ++_numAllocationsStartedProcessing, _totalNumAllocations);
            CreateLookupManager();
            DateTime? contractApprovedDate = GetContractApprovedDate(allocation.contractReference);
            string allocationNumber = allocation.contractAllocationNumber;
            int contractVersion = allocation.contractReference.contractVersionNumber;
            AllocationDeliveryCommencedHandler allocationDeliveryCommencedHandler =  CreateAllocationDeliveryCommencedHandler(contractApprovedDate, allocationNumber, contractVersion);

            AllocationDeliveryCommencedEvent allocationDeliveryCommencedEvent = new AllocationDeliveryCommencedEvent
            {
                Allocation = allocation
            };
            allocationDeliveryCommencedHandler.Handle(allocationDeliveryCommencedEvent);

            using (var allocationDeliveryDbContext = new AllocationDeliveryDbContext())
            using (var paymentManagementPolicyContext = new PaymentManagementPolicyContext())
            using (var allocationDeliveryMonitoringContext = new AllocationDeliveryMonitoringDbContext())
            {
                ContractAllocationApprovedHandler contractAllocationApprovedHandler = CreateContractAllocationApprovedHandler(contractApprovedDate, allocationDeliveryDbContext, paymentManagementPolicyContext, allocationDeliveryMonitoringContext);
                Mock<IPaymentSchedulePolicyContext> mockPaymentSchedulePolicyContext = new Mock<IPaymentSchedulePolicyContext>();
                mockPaymentSchedulePolicyContext.Setup(m => m.Allocations)
                    .Returns(CreateAllocationsMockDbSet(allocationNumber, contractVersion));
                contractAllocationApprovedHandler.PaymentSchedulePolicyContext = mockPaymentSchedulePolicyContext.Object;
                contractAllocationApprovedHandler.Handle(allocationDeliveryCommencedEvent); 
            }
            
            _paymentScheduleEvents.ForEach(pse => ProcessPaymentScheduleEvent(pse, contractApprovedDate, allocationNumber, contractVersion));
            _paymentScheduleEvents.Clear();
        }

        private IDbSet<Allocation> CreateAllocationsMockDbSet(string allocationNumber, int contractVersion)
        {
            return EfHelper.GetQueryableMockDbSet(new Allocation
            {
                AllocationNumber = allocationNumber,
                ContractVersionNumber = contractVersion
            });
        }

        private void CreateLookupManager()
        {
            _lookupManager = new LookupManager();
            _lookupManager.EnduringCacheManager = new EnduringCacheManager();
            _lookupManager.BatchCacheManager = new BatchCacheManager();
            CrmConnection xrmConnection =
               CrmConnection.Parse(ConfigurationManager.ConnectionStrings["CrmConnectionString"].ConnectionString);
            _lookupManager.OrganizationService = new OrganizationService(xrmConnection);
        }

        private DateTime? GetContractApprovedDate(contractReferenceType contractReference)
        {
            string contractKey = contractReference.contractNumber + contractReference.contractVersionNumber;
            if (!_contractApprovedDates.ContainsKey(contractKey))
            {
                
                bool lookupOk = false;
                int numAttempts = 0;
                do
                {
                    try
                    {
                        // call Ash's Lookup Manager
                        _contractApprovedDates[contractKey] = _lookupManager.GetApprovedDateForContract(contractReference.contractNumber,
                    contractReference.contractVersionNumber);
                        lookupOk = true;
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("Crm lookup failed {0}", e.Message);
                    }
                } while (!lookupOk || ++numAttempts < 3);

                if (!_contractApprovedDates.ContainsKey(contractKey))
                {
                    // we have tried but failed to get the date for this contract so store a null
                    _contractApprovedDates[contractKey] = null;
                    Console.WriteLine("*Failed to get approved date for contract {0} and verion {1}", contractReference.contractNumber, contractReference.contractVersionNumber);
                }
            }
           
            return _contractApprovedDates[contractKey];
        }

        private void ProcessPaymentScheduleEvent(PaymentScheduleEvent paymentScheduleEvent, DateTime? contractApprovedDate, string allocationNumber, int contractVersion)
        {
            PaymentScheduleHandler handler = CreatePaymentScheduleHandler(contractApprovedDate, allocationNumber, contractVersion);
            handler.Handle(paymentScheduleEvent);

            using (var allocationDeliveryDbContext = new AllocationDeliveryDbContext())
            using (var paymentManagementPolicyContext = new PaymentManagementPolicyContext())
            using (var allocationDeliveryMonitoringContext = new AllocationDeliveryMonitoringDbContext())
            {
                ContractAllocationApprovedHandler contractAllocationApprovedHandler = CreateContractAllocationApprovedHandler(contractApprovedDate, allocationDeliveryDbContext, paymentManagementPolicyContext, allocationDeliveryMonitoringContext);
                
                contractAllocationApprovedHandler.Handle(paymentScheduleEvent);
            }
            
            _paymentAggregatedEvents.ForEach(pae =>  ProcessPaymentAggregatedEvent(pae, contractApprovedDate));
            _paymentAggregatedEvents.Clear();
        }

        private void ProcessPaymentAggregatedEvent(PaymentAggregatedEvent paymentAggregatedEvent, DateTime? contractApprovedDate)
        {
            using (var allocationDeliveryDbContext = new AllocationDeliveryDbContext())
            using (var paymentManagementPolicyContext = new PaymentManagementPolicyContext())
            using (var allocationDeliveryMonitoringContext = new AllocationDeliveryMonitoringDbContext())
            {
                ContractAllocationApprovedHandler contractAllocationApprovedHandler = CreateContractAllocationApprovedHandler(contractApprovedDate, allocationDeliveryDbContext, paymentManagementPolicyContext, allocationDeliveryMonitoringContext);
                
                contractAllocationApprovedHandler.Handle(paymentAggregatedEvent);
            }
        }

        private PaymentScheduleHandler CreatePaymentScheduleHandler(DateTime? contractApprovedDate, string allocationNumber, int contractVersion)
        {
            Mock<IBus> busMock = new Mock<IBus>();
            busMock.Setup(m => m.CurrentMessageContext.Headers[It.IsAny<string>()]).Returns(Guid.NewGuid().ToString);
            busMock.Setup(m => m.Publish(It.IsAny<PaymentAggregatedEvent>()))
                .Callback<object>(m => _paymentAggregatedEvents.Add((PaymentAggregatedEvent)m));
            Mock<IPaymentManagementDBContext> paymentManagerDbContextMock = new Mock<IPaymentManagementDBContext>();
            paymentManagerDbContextMock.Setup(m => m.PaymentScheduleIds).Returns(GetEmptyDbSet<PaymentScheduleId>());
            PaymentScheduleHandler handler = new PaymentScheduleHandler
            {
                Bus = busMock.Object,
                PaymentManager = CreatePaymentManager(contractApprovedDate, allocationNumber, contractVersion),
                PaymentManagementDbContext = paymentManagerDbContextMock.Object,
                PaymentManagementPolicyContext = PaymentManagementPolicyContext,
                Logger = new LoggerNullObject()
            };

            return handler;
        }

        private IDbSet<T> GetEmptyDbSet<T>() where T : class, new()
        {
            IDbSet<T> dbSet = EfHelper.GetQueryableMockDbSet(
                new T());

            return dbSet;
        }

        private AllocationDeliveryCommencedHandler CreateAllocationDeliveryCommencedHandler(DateTime? contractApprovedDate, string allocationNumber, int contractVersion)
        {
            AllocationDeliveryCommencedHandler handler = new AllocationDeliveryCommencedHandler();
            Mock<IBus> busMock = new Mock<IBus>();
            Mock<IPaymentManagementDBContext> paymentManagerMock = new Mock<IPaymentManagementDBContext>();

            busMock.Setup(m => m.Publish(It.IsAny<PaymentScheduleEvent>()))
                  .Callback<object>(AddToPaymentScheduleList);
            busMock.Setup(m => m.CurrentMessageContext.Headers[It.IsAny<string>()]).Returns(Guid.NewGuid().ToString);
            paymentManagerMock.Setup(m => m.ContractApprovedIds).Returns(GetEmptyDbSet<ContractApprovedId>());

            handler.PaymentManagementDbContext = paymentManagerMock.Object;
            handler.Logger = _loggerMock.Object;
            handler.PaymentManager = CreatePaymentManager(contractApprovedDate, allocationNumber, contractVersion);
            handler.Bus = busMock.Object;
            handler.ForceMessageSend = true;

            return handler;
        }

        private void AddToPaymentScheduleList(object obj)
        {
            _paymentScheduleEvents.Add((PaymentScheduleEvent) obj);
        }

        private ContractAllocationApprovedHandler CreateContractAllocationApprovedHandler(DateTime? contractApprovedDate, AllocationDeliveryDbContext allocationDeliveryDbContext,
            PaymentManagementPolicyContext paymentManagementPolicyContext, AllocationDeliveryMonitoringDbContext allocationDeliveryMonitoringDbContext)
        {
            if (_contractAllocationApprovedHandler == null)
            {
                _contractAllocationApprovedHandler = new ContractAllocationApprovedHandler();
                _contractAllocationApprovedHandler.Logger = new LoggerNullObject();
                
                _contractAllocationApprovedHandler.Mapper = new AllocationDeliveryPerformanceMapper
                {
                    Logger = new LoggerNullObject()
                };
            }

            IDate dateObject = CreateDateObject(contractApprovedDate);
            _contractAllocationApprovedHandler.Repository = new AllocationDeliveryMonitoringRepository(allocationDeliveryDbContext,
                    paymentManagementPolicyContext, allocationDeliveryMonitoringDbContext, dateObject);
            _contractAllocationApprovedHandler.DateService = dateObject;
            _contractAllocationApprovedHandler.AtomGenerator = CreateAtomGenerator(dateObject);
            return _contractAllocationApprovedHandler; 
        }

        private IAtomGenerator CreateAtomGenerator(IDate dateObject)
        {
            IAtomItemCreator atomItemCreator = new AtomItemCreator(PaymentSchedulePolicyContext, new MonitoringDeliverablesDbContext(), new AllocationDeliveryMonitoringDbContext(), new DataAccessManager() { Context = new PaymentGenerationDbContext() });
            IAtomGenerator atomGenerator = new AtomGenerator(atomItemCreator, AllocationDeliveryDbContext, dateObject);
            return atomGenerator;
        }

        private PaymentManager CreatePaymentManager(DateTime? contractApprovedDate, string allocationNumber, int contractVersion)
        {
            if (_paymentManager == null)
            {
                RulesEngine rulesEngine = new RulesEngine();
                
                _paymentManager = new PaymentManager
                {
                    DateManager = CreateDateObject(contractApprovedDate),
                    PaymentManagementPolicyContext = PaymentManagementPolicyContext,
                    RulesEngine = rulesEngine,
                    Logger = _loggerMock.Object
                };
            }

            _paymentManager.PaymentSchedulePolicyContext = CreatePaymentSchedulePolicyContext(allocationNumber, contractVersion); 

            return _paymentManager;
        }

        private IPaymentSchedulePolicyContext CreatePaymentSchedulePolicyContext(string allocationNumber, int contractVersion)
        {
            using (var context = new PaymentSchedulePolicyContext())
            {
                IDbSet<Allocation> allocations = EfHelper.GetQueryableMockDbSet(context.Allocations.Where(a => a.AllocationNumber == allocationNumber &&
                a.VersionNumber == contractVersion).ToArray());

                Mock<IPaymentSchedulePolicyContext> mockContext = new Mock<IPaymentSchedulePolicyContext>();
                mockContext.Setup(m => m.Allocations).Returns(allocations);
                mockContext.Setup(m => m.DeliverablePayments).Returns(EfHelper.GetQueryableMockDbSet(context.DeliverablePayments.Where(dp => dp.AllocationNumber == allocationNumber && dp.VersionNumber == contractVersion).ToArray()));
                mockContext.Setup(m => m.OrganisationIdentifiers).Returns(GetEmptyDbSet<SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model.OrganisationIdentifer>());
                mockContext.Setup(m => m.ProvisionIdentifiers).Returns(GetEmptyDbSet<SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model.ProvisionIdentifier>());

                return mockContext.Object;
            }
        }

        private IDate CreateDateObject(DateTime? dateTime)
        {
            if (dateTime.HasValue)
            {
                return new BespokeDate(dateTime.Value);
            }
            else
            {
                return new SystemDate();
            }
        }

        private class BespokeDate : IDate
        {
            private readonly DateTime _date;
            public BespokeDate(DateTime date)
            {
                _date = date;
            }

            public DateTime GetCalculationDate()
            {
                return _date;
            }

            public DateTime GetCalculationDateWithKey(string key)
            {
                return _date;
            }
        }
    }
}
