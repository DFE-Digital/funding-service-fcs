namespace ContractManagement.DataStore
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage.Exceptions;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Contract = SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract.Contract;

    public class AtomFeedSeedRunner : IAtomFeedSeedRunner
    {
        private readonly ILogger _logger;
        private readonly IApprovedContractAtomItemRepository _repository;
        private const int _loggingId = ContractManagementLoggingEvents.CMSeedApprovedContract;

        public AtomFeedSeedRunner(ILogger logger, IApprovedContractAtomItemRepository repository)
        {
            _logger = logger;
            _repository = repository;
        }

        public void Execute(IEnumerable<Contract> seed)
        {
            _logger.LogInformation(_loggingId, "Beginning seed for {0}", typeof(Contract).Name);

            if (_repository.Any())
            {
                _logger.LogError(_loggingId, "Table is not empty, seed will not be run");
                return;
            }

            var totalSeededEntities = 0;
            foreach (var entity in seed)
            {
                try
                {
                    _logger.LogInformation(_loggingId, "Adding entity: {0} to storage", entity.ToString());
                    _repository.Add(AtomFeedItem.CreateAtomFeedItem(entity, entity.ToString(), AtomItemType.ApprovedContract, xml => true));
                    totalSeededEntities++;
                }
                catch (DuplicateKeyStorageException)
                {
                    _logger.LogError(_loggingId, "Duplicate key storage exception storing entity: {0}", entity.ToString());
                }
                catch (ArgumentException ex)
                {
                    _logger.LogError(_loggingId,"Argument exception storing entity: {0}. Message: {1}", entity.ToString(), ex.Message);
                }
                catch (Exception ex)
                {
                    _logger.LogError(_loggingId, "Unexpected exception of type {0} storing entity: {1}. Message: {2}",
                        ex.GetType().Name, "Argument exception storing entity: {0}. Message: {1}", ex.Message);
                }
            }

            _logger.LogInformation(_loggingId, "Seed ended, seeded {0} entities", totalSeededEntities);
        }

        public void ExecuteInParallel(IEnumerable<ContractSummary> contractSummaries)
        {
            int beginningIndex = 0;
            var summaries = contractSummaries.ToList();
            int numSummariesToRunInParallel = summaries.Count / 10;
            
            IList<System.Threading.Tasks.Task> taskList = new List<System.Threading.Tasks.Task>();
            do
            {
                var sliceOfSummaries = summaries.GetRange(beginningIndex, Math.Min(numSummariesToRunInParallel, summaries.Count - beginningIndex));
                taskList.Add(System.Threading.Tasks.Task.Run(() =>
                {
                    PersistContracts(sliceOfSummaries);
                }));
                beginningIndex += sliceOfSummaries.Count;
            } while (beginningIndex < summaries.Count);

            System.Threading.Tasks.Task.WaitAll(taskList.ToArray());
        }

        public void PersistContracts(IEnumerable<ContractSummary> contractSummaries)
        {
            foreach (var summary in contractSummaries)
            {
                using (var context = new ContractManagementDbContext())
                {
                    var repository = new ApprovedContractAtomItemRepository(context);
                
                    try
                    {
                        _logger.LogInformation(_loggingId,
                            "Getting full contract for: Master - {0} Contract {1} Version {2} from CRM",
                            summary.MasterContractNumber, summary.ContractNumber, summary.ContractVersionNumber);
                        Contract contractEntity = summary.GetFullCorpContract();

                        if (contractEntity != null && contractEntity.contracts.Any())
                        {
                            var childContract = contractEntity.contracts[0];
                            EnrichContractProperties(childContract);

                            DateTime? approvedDate = contractEntity.GetFirstContractApprovalDate();
                            if (approvedDate.HasValue)
                            {
                                AtomFeedItem atomFeedItem = CreateAtomFeedItem(contractEntity, approvedDate.Value);
                                repository.Add(atomFeedItem);
                                _logger.LogInformation(_loggingId,
                                    "Added full contract for: Master - {0} Contract {1} Version {2} to database",
                                    summary.MasterContractNumber, summary.ContractNumber, summary.ContractVersionNumber);
                            }
                            else
                            {
                                _logger.LogError(_loggingId,
                                    "** This contract does not have an approved date for: Master - {0} Contract {1} Version {2} so cannot be stored",
                                    summary.MasterContractNumber, summary.ContractNumber, summary.ContractVersionNumber);
                            }
                        }
                        else
                        {
                            _logger.LogInformation(_loggingId,
                            "No contract found for Master - {0} Contract {1} Version {2}",
                            summary.MasterContractNumber, summary.ContractNumber, summary.ContractVersionNumber);
                        }
                    }
                    catch (DuplicateKeyStorageException e)
                    {
                        _logger.LogError(_loggingId, "Duplicate key storage exception storing entity for Master - {0} Contract {1} Version {2} : {0}",
                                summary.MasterContractNumber, summary.ContractNumber, summary.ContractVersionNumber, e.Message);
                    }
                    catch (Exception e)
                    {
                        _logger.LogError(_loggingId,
                                "** This contract has failed: Master - {0} Contract {1} Version {2} so cannot be stored. Error - {3}",
                                summary.MasterContractNumber, summary.ContractNumber, summary.ContractVersionNumber, e.Message);
                        if (e.InnerException != null && e.InnerException.InnerException != null)
                        {
                            e = e.InnerException.InnerException;
                        }
                        else if (e.InnerException != null)
                        {
                            e = e.InnerException;
                        }

                        _logger.LogError(_loggingId, "** Inner Exception -{0}", e);
                    }
                }
            }
        }

        private static void EnrichContractProperties(SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract.contractType childContract)
        {
            if (childContract.contractStatus.parentStatus == contractStatusTypeParentStatus.Replaced)
            {
                childContract.contractStatus.parentStatus = contractStatusTypeParentStatus.Approved;
                childContract.StatusLastUpdatedDate = childContract.ContractApprovalDate;
                childContract.LastModifiedDate = childContract.ContractApprovalDate;
            }
        }

        private AtomFeedItem CreateAtomFeedItem(Contract contractEntity, DateTime contractApprovedDate)
        {
            AtomFeedItem atomFeedItem;
            if (contractApprovedDate != DateTime.MinValue)
            {
                atomFeedItem = AtomFeedItem.CreateAtomFeedItem(contractEntity,
                    contractEntity.GetFirstContractNumber(), AtomItemType.ApprovedContract,
                    contractApprovedDate);
            }
            else
            {
                atomFeedItem = AtomFeedItem.CreateAtomFeedItem(contractEntity,
                    contractEntity.GetFirstContractNumber(), AtomItemType.ApprovedContract, xml => true);
            }

            return atomFeedItem;
        }
    }
}