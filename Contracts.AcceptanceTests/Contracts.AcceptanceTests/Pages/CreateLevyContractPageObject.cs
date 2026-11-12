namespace SFA.FCT.Contracts.AcceptanceTests.Pages
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using System.Net;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Security;
    using System.Xml;
    using System.Xml.Linq;
    using System.Xml.Schema;
    using AllocationDeliveryDomain.Common.DataStore;
    using ContractManagementService.Common;
    using ContractManagementService.Common.Commands;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using ContractRequestDomain.Common.Commands;
    using CrossDomain.Integration.Common.Storage;
    using CrossDomain.Integration.Entities.Xrm;
    using CrossDomain.Integration.Entities.Xrm.OptionSets;
    using DAS.Events.Api.Types;
    using DTO;
    using DTO.Levy;
    using Extensions;
    using Infrastructure.Repositories;
    using Infrastructure.Services;
    using Microsoft.SharePoint.Client;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Messages;
    using MoreLinq;
    using OrganisationDomain.Integration.DataStore;
    using OrganisationDomain.Integration.DataStore.Model;
    using Utilities;
    using ContractRequest = CrossDomain.Integration.Entities.ContractRequest;
    using CorporateContract = CrossDomain.Integration.Entities.CorporateSchema.Contract;
    using Dapper;
    using NUnit.Framework.Legacy;

    public class CreateLevyContractPageObject
    {
        private ContractRequest.contractRequestType _stepBuiltContractRequestType;
        private ContractInfo _createdContractInfo;
        private readonly IOrganizationService _organizationService;
        private PdfAdapter _pdfAdapter;
        private readonly DasCommitmentStubRepository _dasCommitmentStubRepository;

        public CreateLevyContractPageObject()
        {
            _organizationService = CrmConnectionFactory.GetConnection();
            _dasCommitmentStubRepository = new DasCommitmentStubRepository();
        }

        public Guid CreatedContractGuid => _createdContractInfo.ContractGuid;

        public string CreatedContractNumber => _createdContractInfo.ContractNumber;

        public bool HasContractOwner => _createdContractInfo.HasOwner;

        public string TargetFileName { get; set; }

        public string DocumentLocation { get; set; }

        public bool UseAzureStorageForDocuments
        {
            get { return TestConfiguration.Configuration["AzureStorage:UseForDocuments"] == "true"; }
        }

        public string AzureDocumentContainerName
        {
            get { return TestConfiguration.Configuration["DocumentGeneration:TargetContainer"]; }
        }

        public void SetStepBuiltContractRequestType(ContractRequest.contractRequestType contractRequestType)
        {
            _stepBuiltContractRequestType = contractRequestType;
        }

        public void SetStepBuiltContractRequestTypeAllocations(
            IEnumerable<ContractRequest.contractAllocation> allocations)
        {
            _stepBuiltContractRequestType.contract.contracts.Single().contractAllocations =
                new List<ContractRequest.contractAllocation>(allocations);
        }

        public void SetStepBuiltContractRequestTypeDeliverables(
            IEnumerable<ContractRequest.contractDeliverable> deliverables)
        {
            _stepBuiltContractRequestType.contract.contracts.Single().contractAllocations
                .ForEach(a => a.contractDeliverables = new List<ContractRequest.contractDeliverable>(
                    deliverables.Where(d => d.deliverable.fundingStreamCode == a.fundingStreamCode)));
        }

        public IReadOnlyCollection<ContractWorkflow> GetWorkflowHistoryActionNamesForContract()
        {
            using (var xrmContext = new XrmServiceContext(_organizationService))
            {
                var workflowForContract =
                    xrmContext.sfa_contracttransitionhistorySet.Where(
                        history => history.sfa_Contract.Id == _createdContractInfo.ContractGuid)
                        .Select(history => new
                        {
                            Action = history.sfa_name,
                            PreviousContractOwner = history.sfa_PreviousContractOwner,
                            NewContractOwner = history.sfa_NewContractOwner
                        })
                        .ToList();

                return
                    workflowForContract.Select(
                        wf =>
                            new ContractWorkflow(wf.Action, wf.PreviousContractOwner, wf.NewContractOwner)).ToList();
            }
        }

        public DTO.Levy.ContractInfo GetMostRecentContractInfo()
        {
            using (var xrmContext = new XrmServiceContext(_organizationService))
            {
                var contract = xrmContext.sfa_contractSet
                    .Where(c => c.sfa_number == _createdContractInfo.ContractNumber)
                    .OrderByDescending(c => c.CreatedOn)
                    .First();

                var statuses = xrmContext.sfa_statusSet.Where(s => s.Id == contract.sfa_SubStatus.Id).ToList();

                return new DTO.Levy.ContractInfo(contract, statuses.First().sfa_name);
            }
        }

        public ContractHeaderInfo GetLatestContractHeaderInfo()
        {
            using (XrmServiceContext xrmContext = new XrmServiceContext(_organizationService))
            {
                return (
                    from c in xrmContext.sfa_contractSet
                    join ft in xrmContext.sfa_fundingtypeSet on c.sfa_FundingType.Id equals ft.Id
                    join p in xrmContext.sfa_periodSet on c.sfa_PeriodId.Id equals p.Id
                    join pt in xrmContext.sfa_periodtypeSet on p.sfa_PeriodTypeId.Id equals pt.Id
                    join ct in xrmContext.sfa_contracttypeSet on c.sfa_ContractType.Id equals ct.Id
                    join o in xrmContext.AccountSet on c.sfa_UKPRN equals o.sfa_UKPRN
                    where
                        c.sfa_number == _createdContractInfo.ContractNumber &&
                        c.sfa_Version == _createdContractInfo.ContractVersion
                    select new ContractHeaderInfo
                    {
                        ContractStartDate = c.sfa_StartDate,
                        ContractEndDate = c.sfa_EndDate,
                        ContractValue = c.sfa_ContractValue.Value,
                        FundingTypeCode = ft.sfa_fundingtypecode,
                        ContractType = ct.sfa_name,
                        Period = int.Parse(p.sfa_Period),
                        PeriodTypeCode = pt.sfa_periodtypecode,
                        Ukprn = int.Parse(c.sfa_UKPRN),
                        LegalName = o.Name,
                        OrganisationId = o.sfa_OrganisationID
                    }).Single();
            }
        }

        public IList<ContractAllocationInfo> GetLatestContractAllocationInfos()
        {
            using (XrmServiceContext xrmContext = new XrmServiceContext(_organizationService))
            {
                return (
                    from a in xrmContext.sfa_contractallocationSet
                    join c in xrmContext.sfa_contractSet on a.sfa_ContractId.Id equals c.Id
                    join fs in xrmContext.sfa_fundingstreamSet on a.sfa_FundingStreamId.Id equals fs.Id
                    join fsp in xrmContext.sfa_fundingstreamperiodSet on a.sfa_FundingStreamPeriodId.Id equals fsp.Id
                    join p in xrmContext.sfa_periodSet on fsp.sfa_PeriodId.Id equals p.Id
                    join pt in xrmContext.sfa_periodtypeSet on p.sfa_PeriodTypeId.Id equals pt.Id
                    where
                        c.sfa_number == _createdContractInfo.ContractNumber &&
                        c.sfa_Version == _createdContractInfo.ContractVersion
                    select new ContractAllocationInfo
                    {
                        AllocationStartDate = a.sfa_startdate,
                        AllocationEndDate = a.sfa_enddate,
                        FundingStreamCode = fs.sfa_fundingstreamcode,
                        FundingStreamPeriodCode = fsp.sfa_fundingstreamperiodcode,
                        Period = int.Parse(p.sfa_Period),
                        PeriodTypeCode = pt.sfa_periodtypecode
                    }).ToList();
            }
        }

        public IList<ContractDeliverablePeriodInfo> GetContractDeliverablePeriodInfos(string contractNumber)
        {
            using (XrmServiceContext xrmContext = new XrmServiceContext(_organizationService))
            {
                List<ContractDeliverablePeriodInfo> contractDeliverablePeriods = (
                    from dp in xrmContext.sfa_contractdeliverableperiodSet
                    join d in xrmContext.sfa_contractdeliverableSet on dp.sfa_ContractDeliverableId.Id equals d.Id
                    join a in xrmContext.sfa_contractallocationSet on d.sfa_ContractAllocationId.Id equals a.Id
                    join c in xrmContext.sfa_contractSet on a.sfa_ContractId.Id equals c.Id
                    join fs in xrmContext.sfa_fundingstreamSet on a.sfa_FundingStreamId.Id equals fs.Id
                    where
                        c.sfa_number == contractNumber
                        && c.sfa_LatestVersion == true
                    select new ContractDeliverablePeriodInfo
                    {
                        DeliverableCode = int.Parse(d.sfa_DeliverableCode),
                        ParentDeliverableCode = null,
                        DeliverableDescription = d.sfa_DeliverableDescription,
                        DeliverablePlannedValue = d.sfa_PlannedValue,
                        Month = dp.sfa_Period,
                        Year = dp.sfa_Year,
                        PlannedValue = dp.sfa_PlannedValue,
                        FundingStreamCode = fs.sfa_fundingstreamcode,
                        NetPaymentAmount = dp.sfa_NetPaymentAmount,
                        ReconciliationAmount = dp.sfa_ReconciliationPaymentAmount,
                        BalancingAmount = dp.sfa_BalancingPaymentAmount,
                        AllocationNumber = a.sfa_contractallocationnumber,
                        CappingAmount = dp.sfa_CappedPaymentAmount
                    }).ToList();

                EnrichContractDeliverablePeriodsWithLatestParentDeliverableCodes(contractDeliverablePeriods);
                // left join not supported in Linq to CRM, hence additional query for parent deliverables

                return contractDeliverablePeriods;
            }
        }

        private void EnrichContractDeliverablePeriodsWithLatestParentDeliverableCodes(
            List<ContractDeliverablePeriodInfo> contractDeliverablePeriods)
        {
            using (XrmServiceContext xrmContext = new XrmServiceContext(_organizationService))
            {
                var contractDeliverableRelationships = (
                    from d in xrmContext.sfa_contractdeliverableSet
                    join pd in xrmContext.sfa_contractdeliverableSet on d.sfa_ParentDeliverableId.Id equals pd.Id
                    join a in xrmContext.sfa_contractallocationSet on d.sfa_ContractAllocationId.Id equals a.Id
                    join c in xrmContext.sfa_contractSet on a.sfa_ContractId.Id equals c.Id
                    where
                        c.sfa_number == _createdContractInfo.ContractNumber &&
                        c.sfa_Version == _createdContractInfo.ContractVersion
                    select new
                    {
                        AllocatonNumber = a.sfa_contractallocationnumber,
                        ParentDeliverableCode = int.Parse(pd.sfa_DeliverableCode),
                        ChildDeliverableCode = int.Parse(d.sfa_DeliverableCode)
                    }).ToList();

                contractDeliverablePeriods.ForEach(dp =>
                {
                    var relationship =
                        contractDeliverableRelationships.SingleOrDefault(
                            pd => pd.ChildDeliverableCode == dp.DeliverableCode
                                  && pd.AllocatonNumber == dp.AllocationNumber);
                    dp.ParentDeliverableCode = relationship?.ParentDeliverableCode;
                });
            }
        }

        public bool PopulateCreatedContract(string ukprn)
        {
            CheckResultPoller checkResultPoller = new CheckResultPoller(checkResult: () =>
            {
                _createdContractInfo = GetLatestContractInfoForUkprn(ukprn);

                return _createdContractInfo.ContractGuid != Guid.Empty;
            },
                maxNumChecks: 30,
                waitIntervalSeconds: 6);
            return checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();
        }

        public bool PopulateCreatedLevyContract(string ukprn, string status = "Draft")
        {
            CheckResultPoller checkResultPoller = new CheckResultPoller(checkResult: () =>
            {
                _createdContractInfo = GetLatestContractInfoForUkprnAndStatus(ukprn, status);

                return _createdContractInfo.ContractGuid != Guid.Empty;
            },
                maxNumChecks: 50,
                waitIntervalSeconds: 2);
            return checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();
        }

        public bool DoesTaskExistForContract(Guid contractGuid)
        {
            using (var xrmContext = new XrmServiceContext(_organizationService))
            {
                return xrmContext.TaskSet.Where(ts => ts.RegardingObjectId.Id == CreatedContractGuid).ToList().Any();
            }
        }

        public void DeleteCaseloadForUkrpn(int ukprn)
        {
            using (var xrmContext = new XrmServiceContext(_organizationService))
            {
                var caseloadsToDelete = xrmContext.sfa_caseloadSet.Where(c => c.sfa_UKPRN == ukprn.ToString()).ToList();

                caseloadsToDelete.ForEach(cl => _organizationService.Delete(sfa_caseload.EntityLogicalName, cl.Id));
            }
        }

        //public void RemoveDocumentsForUkPrnFromOffice365Folder(string office365Location, string ukPrn)
        //{
        //    using (var clientContext = SharePointAuthenticationHelper.GetClientContext())
        //    {
        //        var files = GetFilesByBeginsWithQuery(clientContext, ukPrn, office365Location);
        //        if (files == null)
        //        {
        //            return;
        //        }

        //        for (int i = 0; i < files.Count; i++)
        //        {
        //            files[i].DeleteObject();
        //        }

        //        clientContext.ExecuteQuery();
        //    }
        //}


        public void RemoveDocumentsForUkPrnFromOffice365Folder(string office365Location, string ukPrn)
        {
            SharePointAuthenticationHelper.RemoveFilesByPrefix_Graph(office365Location, ukPrn);
        }

        //public bool IsContractDocumentWithSpecifiedNamePresentInOffice365(string ukPrn, string contractNumber,
        //    string fileVersion, string location)
        //{
        //    string fileName = ukPrn + contractNumber + fileVersion;

        //    TargetFileName = fileName;
        //    DocumentLocation = location;

        //    using (var clientContext = SharePointAuthenticationHelper.GetClientContext())
        //    {
        //        return GetFile(clientContext, fileName, location) != null;
        //    }
        //}


        public bool IsContractDocumentWithSpecifiedNamePresentInOffice365(string ukPrn, string contractNumber,
            string fileVersion, string location)
        {
            string fileName = ukPrn + contractNumber + fileVersion;

            TargetFileName = fileName;
            DocumentLocation = location;

            return SharePointAuthenticationHelper.FileExists_Graph(location, fileName);
        }


        //public bool IsContractDocumentWithSpecifiedNameNotPresentInOffice365(string ukPrn, string contractNumber,
        //    string fileVersion, string location)
        //{
        //    string fileName = ukPrn + contractNumber + fileVersion;

        //    TargetFileName = fileName;
        //    DocumentLocation = location;

        //    using (var clientContext = SharePointAuthenticationHelper.GetClientContext())
        //    {
        //        return GetFile(clientContext, fileName, location) == null;
        //    }
        //}


        public bool IsContractDocumentWithSpecifiedNameNotPresentInOffice365(string ukPrn, string contractNumber,
            string fileVersion, string location)
        {
            string fileName = ukPrn + contractNumber + fileVersion;

            TargetFileName = fileName;
            DocumentLocation = location;

            return !SharePointAuthenticationHelper.FileExists_Graph(location, fileName);
        }


        //private static Microsoft.SharePoint.Client.File GetFile(ClientContext context, string fileName, string listName)
        //{
        //    string relativeUrl = listName;
        //    Folder folder;

        //    folder = context.Web.Lists.GetByTitle(listName).RootFolder;

        //    context.Load(folder.Files);
        //    context.ExecuteQuery();

        //    if (folder.Files.Count > 0)
        //        return folder.Files.ToList().FirstOrDefault(p => p.Name == fileName);
        //    else
        //        return null;
        //}

        public string GetLatestContractNumberForUkprn(string ukPrn)
        {
            using (XrmServiceContext context = new XrmServiceContext(_organizationService))
            {
                return context.sfa_contractSet.Where(c =>
                    c.sfa_UKPRN == ukPrn && c.sfa_HierarchyType.Value == (int)sfa_contracthierarchytype.Contract
                    && c.sfa_LatestVersion.Value).OrderByDescending(x => x.CreatedOn)
                    .First().sfa_number;
            }
        }

        //private ListItemCollection GetFilesByBeginsWithQuery(ClientContext context, string beginWithFileName,
        //    string listName)
        //{
        //    // Find the file by name
        //    var camlQuery = new CamlQuery
        //    {
        //        ViewXml = @"<View>
        //                        <Query>
        //                            <Where>
        //                            <BeginsWith>
        //                                <FieldRef Name=""FileLeafRef"" />
        //                                <Value Type=""Text"">" + beginWithFileName + @"</Value>
        //                            </BeginsWith>
        //                            </Where>
        //                            <OrderBy>
        //                                <FieldRef Name='FileLeafRef' />
        //                            </OrderBy>
        //                         </Query>
        //                    </View>"
        //    };

        //    var list = context.Web.Lists.GetByTitle(listName);
        //    var listItems = list.GetItems(camlQuery);
        //    context.Load(listItems, items => items.Include(item => item.File.Name));
        //    context.ExecuteQuery();

        //    if (listItems.Count > 0)
        //    {
        //        return listItems;
        //    }

        //    return null;
        //}

        private ContractInfo GetLatestContractInfoForUkprn(string ukprn)
        {
            using (var xrmContext = new XrmServiceContext(_organizationService))
            {
                var contractIds = xrmContext.sfa_contractSet.Where(
                    c => c.sfa_UKPRN == ukprn
                         && (sfa_contracthierarchytype)c.sfa_HierarchyType.Value == sfa_contracthierarchytype.Contract)
                    .Select(c => new
                    {
                        c.Id,
                        c.sfa_number,
                        c.sfa_Version,
                        c.CreatedOn,
                        HasOwner = c.sfa_ContractAdviser != null
                    }).ToList();

                var latestContract = contractIds.OrderByDescending(c => c.CreatedOn).FirstOrDefault();
                if (latestContract != null)
                {
                    return new ContractInfo(latestContract.HasOwner, latestContract.Id, latestContract.sfa_number,
                        latestContract.sfa_Version.GetValueOrDefault());
                }

                return new ContractInfo(false, Guid.Empty, null, 0);
            }
        }

        private ContractInfo GetLatestContractInfoForUkprnAndStatus(string ukprn, string status)
        {
            using (var xrmContext = new XrmServiceContext(_organizationService))
            {
                var enumStatus = Enum.Parse(typeof(sfa_contractstatus), status);
                var contractIds = (from c in xrmContext.sfa_contractSet
                                   join ft in xrmContext.sfa_fundingtypeSet on c.sfa_FundingType.Id equals ft.Id
                                   where c.sfa_UKPRN == ukprn
                                         && (sfa_contracthierarchytype)c.sfa_HierarchyType.Value == sfa_contracthierarchytype.Contract
                                         && ft.sfa_fundingtypecode == "LEVY"
                                         && (c.sfa_ContractStatus.Value == (int)enumStatus)
                                   select new
                                   {
                                       c.Id,
                                       c.sfa_number,
                                       c.sfa_Version,
                                       c.CreatedOn,
                                       c.sfa_ContractStatus,
                                       HasOwner = c.sfa_ContractAdviser != null
                                   }).ToList();

                ClassicAssert.IsFalse(contractIds.Count > 1, "More than 1 draft or approved LEVY contract found for UKPRN");
                var singleContract = contractIds.SingleOrDefault();

                if (singleContract != null)
                {
                    return new ContractInfo(singleContract.HasOwner, singleContract.Id, singleContract.sfa_number,
                        singleContract.sfa_Version.GetValueOrDefault());
                }

                return new ContractInfo(false, Guid.Empty, null, 0);
            }
        }

        private PdfAdapter GetPdfFile(string location = "")
        {
            if (_pdfAdapter == null)
            {
                if (UseAzureStorageForDocuments)
                {
                    _pdfAdapter =
                        new PdfAdapter(
                            new DocumentsDomain.Integration.AzureStorageWrapper().GetBlockBlobContents(new DocumentsDomain
                                .Common.Models.FctFile(
                                AzureDocumentContainerName,
                                TargetFileName)));
                }
                else
                {
                    _pdfAdapter =
                        new PdfAdapter(
                            new Office365StorageWrapper().GetFileContents(
                                !string.IsNullOrEmpty(location) ? location : DocumentLocation, string.Empty,
                                TargetFileName));
                }
            }
            return _pdfAdapter;
        }

        public string GetLatestAllocationNumberForUkprn(string ukPrn)
        {
            using (XrmServiceContext xrmContext = new XrmServiceContext(_organizationService))
            {
                var contractId = xrmContext.sfa_contractSet
                    .Where(
                        c =>
                            c.sfa_UKPRN == ukPrn &&
                            c.sfa_HierarchyType.Value == (int)sfa_contracthierarchytype.Contract
                            && c.sfa_LatestVersion.Value)
                    .OrderByDescending(o => o.CreatedOn)
                    .Select(contract => contract.sfa_contractId)
                    .First();

                return xrmContext.sfa_contractallocationSet
                    .Where(a => a.sfa_ContractId.Id == contractId)
                    .Select(a => a.sfa_contractallocationnumber)
                    .First();
            }
        }

        public bool IsContractManagementAtomFeedItemValidXml(int itemType, string contractNumber)
        {
            AtomFeedItem atomFeedItem = null;
            using (var context = new ContractManagementDbContext())
            {
                atomFeedItem =
                    context.AtomFeedItems.Single(
                        a => a.BusinessKey.StartsWith(contractNumber) && (int)a.ItemType == itemType);
            }

            return IsContractManagementAtomFeedItemValidXml(atomFeedItem.GetAtomFeedItemXml());
        }

        public bool IsContractManagementAtomFeedItemValidXml(int itemType, int versionNumber, string contractNumber)
        {
            AtomFeedItem atomFeedItem = null;
            using (var context = new ContractManagementDbContext())
            {
                var matchingItems = context.AtomFeedItems
                    .Where(a => a.BusinessKey.StartsWith(contractNumber)
                                && (int)a.ItemType == itemType).ToList();

                atomFeedItem = matchingItems.Single(m => m.GetVersionNumber() == versionNumber);
            }

            return IsContractManagementAtomFeedItemValidXml(atomFeedItem.GetAtomFeedItemXml());
        }

        public void SetMasterContractNumberOnPageObject(string featureVariableName, string ukPrn)
        {
            string masterContractNumber = GetMasterContractNumberForLatestContractForGivenUkPrn(ukPrn);
            FeatureVariables.Set(featureVariableName, masterContractNumber);
        }

        public void SimulateSFSAndSendContractApprovalMessageForGivenContract(string masterContractNumber,
            string contractNumber, int contractVersionNumber)
        {
            CallWebAPIEndPointForContract(masterContractNumber, contractNumber, contractVersionNumber,
                "/contractmanagement/contractissueandreturn/confirmreceiptofdigitalsignature");
        }

        public void SimulateSFSAndSendContractApprovalMessageForGivenContractViaBus(string masterContractNumber,
            string contractNumber, int contractVersionNumber)
        {
            InitiateContractApprovalCommand command = new InitiateContractApprovalCommand
            {
                ContractNumber = contractNumber,
                MasterContractNumber = masterContractNumber,
                ContractVersionNumber = contractVersionNumber,
                RequestSource = ApprovalRequestSource.External
            };

            MessageSendingBus.Send("ContractManagementDomain.InitiateContractApproval", command);
        }

        public void RemoveMonthEndHistories()
        {
            using (var context = new ContractManagementDbContext())
            {
                context.Database.ExecuteSqlCommand("truncate table [ContractManagement].[MonthEndHistory]");
            }
        }

        public void CallWebAPIEndPointForContract(string masterContractNumber, string contractNumber, int versionNumber, string endPointUrl)
        {
            using (var client = new HttpClient())
            {
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer",
                    AzureAuthenticator.GetAuthenticationResult());

            string url = TestConfiguration.Configuration["ContractManagement:ServiceUrl"] + endPointUrl;

                ContractInformation contractInformation = new ContractInformation
                {
                    MasterContractNumber = masterContractNumber,
                    ContractNumber = contractNumber,
                    ContractVersionNumber = versionNumber
                };

                HttpResponseMessage response = client.PostAsJsonAsync(url, contractInformation).Result as HttpResponseMessage;
                ClassicAssert.AreEqual(HttpStatusCode.Accepted, response.StatusCode,
                    $"On successfully initiating {endPointUrl} the response should be 'Accepted'. The status returned is {response.StatusCode}");
            }
        }

        private string GetMasterContractNumberForLatestContractForGivenUkPrn(string ukPrn)
        {
            using (XrmServiceContext xrmContext = new XrmServiceContext(_organizationService))
            {
                var contract =
                    xrmContext.sfa_contractSet.Single(
                        c =>
                            c.sfa_UKPRN == ukPrn &&
                            c.sfa_HierarchyType.Value == (int)sfa_contracthierarchytype.Contract
                            && c.sfa_LatestVersion.Value);
                return xrmContext.sfa_contractSet.Single(c =>
                    c.sfa_UKPRN == ukPrn && c.sfa_HierarchyType.Value == (int)sfa_contracthierarchytype.Master
                    && c.Id == contract.sfa_ParentContractId.Id).sfa_number;
            }
        }

        public bool IsOneItemTypePresentInContractManagementAtomFeedForContractNumber(int itemType, string contractNumber)
        {
            CheckResultPoller checkResultPoller = new CheckResultPoller(checkResult: () =>
            {
                using (var context = new ContractManagementDbContext())
                {
                    return
                        context.AtomFeedItems.Count(
                            a => a.BusinessKey.StartsWith(contractNumber) && (int)a.ItemType == itemType) == 1;
                }
            },
                maxNumChecks: 10,
                waitIntervalSeconds: 5
                );

            return checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();
        }

        public bool IsOneItemTypePresentInContractManagementAtomFeedForContractNumberAndVersionNumber(
            int itemType,
            int versionNumber,
            string contractNumber)
        {
            CheckResultPoller checkResultPoller = new CheckResultPoller(checkResult: () =>
            {
                using (var context = new ContractManagementDbContext())
                {
                    var matchItems = context.AtomFeedItems.Where(
                        a => a.BusinessKey.StartsWith(contractNumber)
                             && (int)a.ItemType == itemType).ToList();

                    return matchItems.Count(m => m.GetVersionNumber() == versionNumber) == 1;
                }
            },
                maxNumChecks: 10,
                waitIntervalSeconds: 5
                );

            return checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();
        }

        public int GetCountOfPaymentInstructionAuditRecordsForUkprn(string ukprn, int expectedRowCount)
        {
            int actualNumberOfRecords = 0;

            CheckResultPoller checkResultPoller = new CheckResultPoller(checkResult: () =>
            {
                using (var context = new MonitoringDeliverablesDbContext())
                {
                    actualNumberOfRecords = context.PaymentInstructionAudits.Count(a => a.Ukprn == ukprn);
                    return actualNumberOfRecords == expectedRowCount;
                }
            },
            maxNumChecks: 10,
            waitIntervalSeconds: 5
            );

            checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();

            return actualNumberOfRecords;
        }

        //public void DeleteAndReCreateOffice365Folder(string documentLibrary)
        //{
        //    using (var ctx = SharePointAuthenticationHelper.GetClientContext())
        //    {
        //        // Get site structure
        //        ctx.Load(ctx.Web, w => w.Lists);
        //        ctx.ExecuteQuery();

        //        // Get and delete list
        //        List list = ctx.Web.Lists.GetByTitle(documentLibrary);
        //        list.DeleteObject();
        //        ctx.ExecuteQuery();

        //        // create new list
        //        ListCreationInformation lci = new ListCreationInformation();
        //        lci.Title = documentLibrary;
        //        lci.TemplateType = (int)ListTemplateType.DocumentLibrary;
        //        ctx.Web.Lists.Add(lci);
        //        ctx.ExecuteQuery();
        //    }
        //}


        public void DeleteAndReCreateOffice365Folder(string documentLibrary)
        {
            SharePointAuthenticationHelper.DeleteAndRecreateLibrary_Graph(documentLibrary);
        }

        public void RemoveEventsFrom_ContractManagement_AtomFeedItem_ByItemTypeAndPrefixedBusinessKey(int itemType, string businessKeyPrefix)
        {
            using (var atomFeedItemContext = new ContractManagementDbContext())
            {
                var entriesToRemove = atomFeedItemContext.AtomFeedItems.Where(item => (int)item.ItemType == itemType && item.BusinessKey.StartsWith(businessKeyPrefix));
                entriesToRemove.ForEach(entry => atomFeedItemContext.AtomFeedItems.Remove(entry));

                atomFeedItemContext.SaveChanges();
            }
        }

        public int GetNumberOfRowsFromAtomFeedItemForGivenItemTypeAndPrefixedBusinessKey(int expectedRowCount, int itemType, string businessKeyPrefix)
        {
            int numAtomItemFeedItems = 0;
            CheckResultPoller checkResultPoller = new CheckResultPoller(checkResult: () =>
            {
                using (var context = new ContractManagementDbContext())
                {
                    numAtomItemFeedItems = context.AtomFeedItems.Count(
                        a => a.BusinessKey.StartsWith(businessKeyPrefix)
                             && (int)a.ItemType == itemType);

                    return numAtomItemFeedItems == expectedRowCount;
                }
            },
                maxNumChecks: 10,
                waitIntervalSeconds: 5
                );

            checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();

            return numAtomItemFeedItems;
        }

        public int GetNumberOfContractsWithGivenUkprnPrefix(int expectedRecordsCount, string ukprnPrefix, int maximumNumberOfMinutesToWait)
        {
            var recordsFound = 0;

            CheckResultPoller checkResultPoller = new CheckResultPoller(checkResult: () =>
            {
                using (XrmServiceContext xrmContext = new XrmServiceContext(_organizationService))
                {
                    recordsFound =
                        xrmContext.sfa_contractSet.Where(
                            c =>
                                c.sfa_UKPRN.StartsWith(ukprnPrefix) &&
                                c.sfa_HierarchyType.Value == (int)sfa_contracthierarchytype.Contract).ToList().Count;
                    return recordsFound == expectedRecordsCount;
                }
            },
                maxNumChecks: (maximumNumberOfMinutesToWait * 60) / 30,
                waitIntervalSeconds: 30
                );

            checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();

            return recordsFound;
        }

        public void RemoveEventsFromEngagementEventsTableForAGivenAUkPrnPrefix(string ukprnPrefix)
        {
            using (var contractManagementContext = new ContractManagementDbContext())
            {
                var recordsToDelete = contractManagementContext.EngagementEvents.Where(engagementEvent => engagementEvent.ProviderId.StartsWith(ukprnPrefix));
                recordsToDelete.ForEach(engagementEvent => contractManagementContext.EngagementEvents.Remove(engagementEvent));

                contractManagementContext.SaveChanges();
            }
        }

        public bool IsItemPresentInContractManagementAtomFeedForContractNumberAndVersion(int itemType, int versionNumber, string contractNumber)
        {
            using (var context = new ContractManagementDbContext())
            {
                var matchingItems = context.AtomFeedItems
                    .Where(a => a.BusinessKey.StartsWith(contractNumber) && (int)a.ItemType == itemType)
                    .ToList();

                return matchingItems.Any(m => m.GetVersionNumber() == versionNumber);
            }
        }

        public void VerifyLinesInOrderAndAssertIfNotFound(string location, string multilineText)
        {
            _pdfAdapter = null;
            GetPdfFile(location).VerifyLinesInOrderAndAssertIfNotFound(multilineText);
        }

        public void ClearDasCommitmentsStubRepository()
        {
            _dasCommitmentStubRepository.Clear();
        }

        public void ClearDasEngagementEvents()
        {
            using (ContractManagementDbContext dbContext = new ContractManagementDbContext())
            {
                dbContext.Database.Connection.ExecuteScalar<int>("dbo.sp_DynamicClearData @table,@schema,@ReqType", new { Table = "EngagementEvent", Schema = "ContractManagement", ReqType = "Delete" });
            }
        }

        public void AddDasLevyEventDataToRepository(IEnumerable<AgreementEventView> agreementEventViews)
        {
            _dasCommitmentStubRepository.AddRange(agreementEventViews);
        }

        public void AddDasLevyEventDataToRepositoryFromPath(string path)
        {
            var lines = System.IO.File.ReadAllLines(path);

            List<AgreementEventView> events = new List<AgreementEventView>();

            for (var i = 1; i < lines.Length; i++)
            {
                var splitLine = lines[i].Split(',');
                if (splitLine.Length < 5)
                {
                    break;
                }

                events.Add(new AgreementEventView
                {
                    Id = long.Parse(splitLine[0]),
                    Event = splitLine[1],
                    CreatedOn = DateTime.Parse(splitLine[2]),
                    ProviderId = splitLine[3],
                    EmployerAccountId = splitLine[4]
                });
            }

            _dasCommitmentStubRepository.AddRange(events);
        }

        public void SendInitiateDasPullAndRetryNotFoundCommands()
        {
            MessageSendingBus.Send("ContractRequestDomain.EngagementWatcher", new InitiateEngagementPollingCommand());
            MessageSendingBus.Send("ContractRequestDomain.EngagementWatcher", new RetryNotFoundProviderEngagementsCommand());
        }

        public bool TryToConfirmEngagementEventForProviderInCrm(string ukprn)
        {
            CheckResultPoller checkResultPoller = new CheckResultPoller(checkResult: () =>
            {
                return IsEngagementEventForProviderInCrm(ukprn);
            },
                maxNumChecks: 6,
                waitIntervalSeconds: 10);

            return checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();
        }

        private bool IsEngagementEventForProviderInCrm(string ukprn)
        {
            using (var context = new ContractManagementDbContext())
            {
                return context.EngagementEvents.Any(
                    ee => ee.ProviderId == ukprn && ee.ProcessingState == EngagementEventProcessingState.InCrm);
            }
        }

        private bool IsContractManagementAtomFeedItemValidXml(string corporateContractXml)
        {
            var schemaSet = GetSchemaSetToValidate();

            return IsAtomFeedItemValidXml(schemaSet, corporateContractXml);
        }

        private XmlSchemaSet GetSchemaSetToValidate()
        {
            var schemas = new XmlSchemaSet();
            const string corporateContractSchemaResourceName =
                "SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.contract_corporate_schema_v10.07.xsd";
            const string corporateContractSchemaNamespace = "urn:sfa:schemas:contract";

            var schema =
                typeof(CorporateContract.Contract).Assembly.GetManifestResourceStream(
                    corporateContractSchemaResourceName);
            if (schema != null)
            {
                schemas = new XmlSchemaSet();
                // ReSharper disable once AssignNullToNotNullAttribute
                schemas.Add(corporateContractSchemaNamespace, new XmlTextReader(schema));
            }

            return schemas;
        }

        private bool IsAtomFeedItemValidXml(XmlSchemaSet schemaSet, string xmlContent)
        {
            bool errors = false;

            var xDoc = XDocument.Parse(xmlContent);
            xDoc.Validate(
                schemaSet,
                (o, e) =>
                {
                    new XmlValidationError()
                    {
                        LineNumber = e.Exception.LineNumber,
                        LinePosition = e.Exception.LinePosition,
                        ErrorMessage = e.Exception.Message
                    };
                    errors = true;
                });

            return !errors;
        }

        public long AddInFlightEngagementEventToPaasWithZeroId(int ukprn)
        {
            const long eventId = 0;
            using (var context = new ContractManagementDbContext())
            {
                EngagementEvent engagementEvent =
                    context.EngagementEvents.Add(new EngagementEvent(eventId, EngagementEvent.ValidEventType, ukprn.ToString()));
                engagementEvent.ProcessingState = EngagementEventProcessingState.InFlight;
                context.SaveChanges();
            }

            return eventId;
        }

        public int GetCountOfProviderNotFoundEngagementEventsInPaaS(string ukprn)
        {
            using (var context = new ContractManagementDbContext())
            {
                return
                    context.EngagementEvents.Count(
                        ee =>
                            ee.ProviderId == ukprn &&
                            ee.ProcessingState == EngagementEventProcessingState.ProviderNotFound);
            }
        }

        public int GetCountOfChildContractsForUkprnInCrm(string ukprn)
        {
            return GetChildContractsByUkprn(ukprn).Count;
        }

        private IReadOnlyCollection<sfa_contract> GetChildContractsByUkprn(string ukprn)
        {
            using (XrmServiceContext xrmContext = new XrmServiceContext(_organizationService))
            {
                return
                    xrmContext.sfa_contractSet.Where(
                        c =>
                            c.sfa_UKPRN == ukprn &&
                            c.sfa_HierarchyType.Value == (int)sfa_contracthierarchytype.Contract)
                        .ToList();
            }
        }

        public void RemoveOrgForUkprnFromOrgCache(int ukprn)
        {
            using (var context = new OrganisationDomainDbContext())
            {
                context.Organisations.Where(org => org.Ukprn == ukprn)
                    .ForEach(org => context.Organisations.Remove(org));

                context.SaveChanges();
            }
        }

        public void AddOrgToOrgCacheTable(int ukprn, string status)
        {
            DeleteOrganisationsFromOrgCacheTable(ukprn);

            AddOrganisationFromOrgCacheTable(ukprn, status);
        }

        private void AddOrganisationFromOrgCacheTable(int ukprn, string status)
        {
            using (var context = new OrganisationDomainDbContext())
            {
                context.Organisations.Add(new Organisation
                {
                    Ukprn = ukprn,
                    Upin = new Random().Next(1, int.MaxValue),
                    SequenceNumber = 1,
                    TradingName = "Test org",
                    Status = status
                });

                context.SaveChanges();
            }
        }

        private void DeleteOrganisationsFromOrgCacheTable(int ukprn)
        {
            using (var context = new OrganisationDomainDbContext())
            {
                var matchingOrgs = context.Organisations.Where(o => o.Ukprn == ukprn);
                matchingOrgs.ForEach(o => context.Organisations.Remove(o));

                context.SaveChanges();
            }
        }

        public bool IsProviderNotFoundEventPresentForUkprn(int ukprn)
        {
            using (var context = new ContractManagementDbContext())
            {
                return context.EngagementEvents
                    .Any(
                        ee =>
                            ee.ProviderId == ukprn.ToString() &&
                            ee.ProcessingState == EngagementEventProcessingState.ProviderNotFound);
            }
        }

        public int GetProviderNotFoundEventsWithUkprnPrefix(int ukprnPrefix, int expectedNumOfRecords, int numMinsToWait)
        {
            int count = 0;

            CheckResultPoller checkResultPoller = new CheckResultPoller(checkResult: () =>
            {
                using (var context = new ContractManagementDbContext())
                {
                    count = context.EngagementEvents
                              .Count(
                                  e => e.ProcessingState == EngagementEventProcessingState.ProviderNotFound
                                       && e.ProviderId.StartsWith(ukprnPrefix.ToString()));
                }
                return count == expectedNumOfRecords;

            },
                maxNumChecks: (numMinsToWait * 60) / 5,
                waitIntervalSeconds: 5);

            checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();

            return count;
        }

        public void DeleteContractWithPartialUkrn(string ukprnPart, sfa_contracthierarchytype hierarchy)
        {
            using (var context = new XrmServiceContext(_organizationService))
            {
                IEnumerable<DeleteRequest> contractEntities =
                    context.sfa_contractSet.Where(c => c.sfa_UKPRN.StartsWith(ukprnPart)
                                                && c.sfa_HierarchyType.Value == (int)hierarchy)
                           .ToList()
                           .Select(ce => new DeleteRequest { Target = ce.ToEntityReference() });

                var batchedDeleteRequests = CreateBatchDeleteRequests(contractEntities);

                batchedDeleteRequests.ForEach(batch => DeleteBatchedDeleteRequest(context, batch));
            }
        }

        public List<AllocationDeliveryDomain.Common.DataStore.Model.PaymentInstructionAudit> GetPaymentInstructionAuditRecordsFromPaas(
            string ukPrn, int expectedRowCount)
        {
            var paymentInstructionAudits = new List<AllocationDeliveryDomain.Common.DataStore.Model.PaymentInstructionAudit>();
            var checkResultPoller = new CheckResultPoller(checkResult: () =>
            {
                using (var context = new MonitoringDeliverablesDbContext())
                {
                    paymentInstructionAudits = context.PaymentInstructionAudits
                        .Where(row => row.Ukprn == ukPrn).ToList();

                }
                return paymentInstructionAudits.Count == expectedRowCount;

            },
             maxNumChecks: 20,
             waitIntervalSeconds: 5);

            checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();

            return paymentInstructionAudits;
        }

        private IEnumerable<IEnumerable<DeleteRequest>> CreateBatchDeleteRequests(IEnumerable<DeleteRequest> deleteRequests)
        {
            const int batchSize = 50;

            return deleteRequests.Batch(batchSize);
        }

        private void DeleteBatchedDeleteRequest(XrmServiceContext context, IEnumerable<DeleteRequest> batch)
        {
            var deleteContractsReq = new ExecuteMultipleRequest
            {
                Requests = new OrganizationRequestCollection(),
                Settings = new ExecuteMultipleSettings
                {
                    ContinueOnError = false,
                    ReturnResponses = false
                }

            };

            deleteContractsReq.Requests.AddRange(batch);
            context.Execute(deleteContractsReq);
        }

        public void RemovePaymentInstructionAuditRowsForUkprn(int ukprn)
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                context.PaymentInstructionAudits.RemoveWhere(pi => pi.Ukprn == ukprn.ToString());
                context.SaveChanges();
            }
        }

        private class ContractInfo
        {
            public ContractInfo(bool hasOwner, Guid contractGuid, string contractNumber, int contractVersion)
            {
                HasOwner = hasOwner;
                ContractGuid = contractGuid;
                ContractNumber = contractNumber;
                ContractVersion = contractVersion;
            }

            public bool HasOwner { get; }

            public Guid ContractGuid { get; }

            public string ContractNumber { get; }

            public int ContractVersion { get; }
        }
    }
}
