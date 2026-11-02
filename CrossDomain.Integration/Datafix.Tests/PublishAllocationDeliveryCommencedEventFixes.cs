namespace Datafix.Tests
{
    //using System;
    //using System.Collections.Generic;
    //using System.Configuration;
    //using System.Linq;
    //using Microsoft.VisualStudio.TestTools.UnitTesting;
    //using Microsoft.Xrm.Client;
    //using Microsoft.Xrm.Client.Services;
    //using Microsoft.Xrm.Sdk;
    //using Moq;
    //using MoreLinq;
    //using NServiceBus;
    //using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    //using SFA.FCT.AllocationDeliveryDomain.MDEnrich.BusinessLogic;
    //using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    //using SFA.FCT.CrossDomain.Integration.Common;
    //using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    //using SFA.FCT.CrossDomain.Integration.Entities.DeliveryAllocation;
    //using SFA.FCT.CrossDomain.Integration.Events;
    //using SFA.FCT.Framework.Logging.Interfaces;

    //[TestClass]
    public class PublishAllocationDeliveryCommencedEventFixes
    {
        // TODO: get commented code working
        //[TestMethod, TestCategory("DataFix_R39")]
        //public void DataFix_21818_PublishAllocationDeliveryCommencedEvent()
        //{
        //    const string masterContractNumber = "SFA-3706";
        //    const string contractNumber = "MAIN-4648";
        //    const string allocationNumber = "16AP-4191";
        //    const int expectedContractVersion = 6;

        //    IContractsManager contractManager = GetContractManager();
        //    IContractAllocationTransformer transformer = new ContractAllocationTransformer { Logger = Mock.Of<ILogger>()};
        //    IMonitoringDeliverableEnrichment enricher = new MonitoringDeliverableEnrichment(new MonitoringDeliverablesDbContext());

        //    contract lastApprovedCorporateContract = contractManager.GetCorporateContract(contractNumber, masterContractNumber);
        //    Assert.IsNotNull(lastApprovedCorporateContract, "Contract not present in CRM");
        //    Assert.AreEqual(expectedContractVersion, lastApprovedCorporateContract.contracts.Single().contractVersionNumber, "Last approved contract version has changed");

        //    contractAllocationsContractAllocation corporateAllocation =
        //        lastApprovedCorporateContract.contracts.Single().contractAllocations.SingleOrDefault(a => a.contractAllocationNumber == allocationNumber);
        //    Assert.IsNotNull(corporateAllocation, "Allocation not present in CRM");

        //    allocationType allocation = transformer.Transform(lastApprovedCorporateContract.contracts.Single(), corporateAllocation, Guid.NewGuid().ToString());

        //    enricher.Enrich(allocation);

        //    using (ISendOnlyBus bus = CreateBus())
        //    {
        //        bus.Publish(new AllocationDeliveryCommencedEvent
        //        {
        //            Allocation = allocation
        //        });
        //    }
        //}

        //[TestMethod, TestCategory("DataFix_R41")]
        //public void DataFix_R41_PublishAllocationDeliveryCommencedEvent()
        //{
        //    /**
        //     * Here we have 4 allocations to 're-approve'.
        //     */
        //    IReadOnlyCollection<SimpleContract> simpleContracts = new List<SimpleContract>
        //    {
        //        new SimpleContract(contractNumber: "MAIN-5594", allocationNumbers: new List<string>{"ANL-2235", "16NL-2186"}, expectedVersion:3, masterContract: "SFA-3613"),
        //        new SimpleContract(contractNumber: "MAIN-5039", allocationNumbers: new List<string>{"16NL-1764", "ANL-1808"}, expectedVersion:3, masterContract: "ESFA-10021"),
        //    };

        //    using (ISendOnlyBus bus = CreateBus())
        //    {
        //        simpleContracts.ForEach(contract => PublishAllocationDeliveryCommencedEventsForSimpleContract(contract, bus));
        //    }
        //}

        //[TestMethod, TestCategory("DataFix_R51")]
        //public void DataFix_R51_PublishAllocationDeliveryCommencedEvent()
        //{
        //    SimpleContract contract = new SimpleContract(
        //        contractNumber: "LOANS-1633",
        //        allocationNumbers: new[] { "ALLF-5633" },
        //        expectedVersion: 2,
        //        masterContract: "ESFA-13277");

        //    using (ISendOnlyBus bus = CreateBus())
        //    {
        //        PublishAllocationDeliveryCommencedEventsForSimpleContract(contract, bus);
        //    }
        //}

        //[TestMethod, TestCategory("DataFix_R51a")]
        //public void DataFix_R51a_PublishAllocationDeliveryCommencedEvent()
        //{
        //    SimpleContract contract = new SimpleContract(
        //        contractNumber: "ESIF-2199",
        //        allocationNumbers: new[] { "ESF-2203" },
        //        expectedVersion: 12,
        //        masterContract: "SFA-6582");

        //    using (ISendOnlyBus bus = CreateBus())
        //    {
        //        PublishAllocationDeliveryCommencedEventsForSimpleContract(contract, bus);
        //    }
        //}

        //private void PublishAllocationDeliveryCommencedEventsForSimpleContract(SimpleContract simpleContract, ISendOnlyBus bus)
        //{
        //    IContractsManager contractManager = GetContractManager();
        //    IContractAllocationTransformer transformer = new ContractAllocationTransformer { Logger = Mock.Of<ILogger>() };
        //    IList<allocationType> enrichedAllocationTypes = new List<allocationType>();

        //    contract lastApprovedCorporateContract = contractManager.GetCorporateContract(simpleContract.ContractNumber, simpleContract.MasterContract);
        //    Assert.IsNotNull(lastApprovedCorporateContract, "Contract not present in CRM");
        //    Assert.AreEqual(simpleContract.ExpectedVersion, lastApprovedCorporateContract.contracts.Single().contractVersionNumber, "Last approved contract version has changed");

        //    simpleContract.AllocationNumbers.ForEach(allocationNumber =>
        //    {
        //        contractAllocationsContractAllocation corporateAllocation =
        //        lastApprovedCorporateContract.contracts.Single().contractAllocations.SingleOrDefault(a => a.contractAllocationNumber == allocationNumber);
        //        Assert.IsNotNull(corporateAllocation, "Allocation not present in CRM");

        //        allocationType allocation = transformer.Transform(lastApprovedCorporateContract.contracts.Single(), corporateAllocation, Guid.NewGuid().ToString());

        //        using (var context = new MonitoringDeliverablesDbContext())
        //        {
        //            IMonitoringDeliverableEnrichment enricher = new MonitoringDeliverableEnrichment(context);
        //            enricher.Enrich(allocation);
        //            enrichedAllocationTypes.Add(allocation);
        //        }
        //    });

        //    enrichedAllocationTypes.ForEach(enrichedAllocationType =>
        //    {
        //        bus.Publish(new AllocationDeliveryCommencedEvent
        //        {
        //            Allocation = enrichedAllocationType
        //        });
        //    });
        //}

        //private class SimpleContract
        //{
        //    public string ContractNumber { get; }

        //    public IReadOnlyCollection<string> AllocationNumbers { get; }

        //    public int ExpectedVersion { get; }

        //    public string MasterContract { get; }

        //    public SimpleContract(string contractNumber, IReadOnlyCollection<string> allocationNumbers, int expectedVersion, string masterContract)
        //    {
        //        ContractNumber = contractNumber;
        //        AllocationNumbers = allocationNumbers;
        //        ExpectedVersion = expectedVersion;
        //        MasterContract = masterContract;
        //    }
        //}

        //private static IContractsManager GetContractManager()
        //{
        //    CrmConnection crmConnection = CrmConnection.Parse(ConfigurationManager.ConnectionStrings["CrmConnectionString"].ConnectionString);
        //    IOrganizationService organizationSvc = new OrganizationService(crmConnection);

        //    return new ContractsManager
        //    {
        //        OrganizationService = organizationSvc
        //    };
        //}

        //private static ISendOnlyBus CreateBus()
        //{
        //    BusConfiguration configuration = new BusConfiguration();
        //    configuration.Conventions().DefiningEventsAs(t => t == typeof(AllocationDeliveryCommencedEvent));
        //    configuration.UseSerialization<JsonSerializer>();
        //    configuration.UseTransport<AzureServiceBusTransport>();
        //    configuration.EnableInstallers();
        //    configuration.EndpointName(FctEndpoint.GenerateEndpointName("AllocationDelivery.MonitoringDeliverablesEnrichment"));

        //    return Bus.CreateSendOnly(configuration);
        //}
    }
}
