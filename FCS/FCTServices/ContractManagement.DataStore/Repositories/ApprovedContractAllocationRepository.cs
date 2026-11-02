namespace ContractManagement.DataStore.Repositories
{
    using System.Collections.Generic;
    using System.Linq;
    using Dapper;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class ApprovedContractAllocationRepository : IApprovedContractAllocationRepository
    {
        private readonly IContractManagementDbContext _dbContext;

        public ApprovedContractAllocationRepository(IContractManagementDbContext dbContext)
        {
            _dbContext = dbContext;
        }

        public void SetOutstandingPaymentsIndicator(string allocationNumber, bool hasOutstandingPayments, ConnectionInfo connectionInfo)
        {
            var ApprovedContractId = (from ac in _dbContext.ApprovedContracts
                                      join aca in _dbContext.ApprovedContractAllocations on ac.ApprovedContractId equals aca.ApprovedContractId
                                      where aca.ContractAllocationNumber == allocationNumber
                                      orderby ac.ApprovedContractId descending
                                      select ac.ApprovedContractId).FirstOrDefault();

            var setOutstandingPaymentsIndicator = _dbContext.ApprovedContractAllocations.Where(
                aca => aca.ContractAllocationNumber == allocationNumber
                && aca.ApprovedContractId == ApprovedContractId).FirstOrDefault();
            if (setOutstandingPaymentsIndicator != null)
            {
                setOutstandingPaymentsIndicator.HasOutstandingPayments = hasOutstandingPayments;
                _dbContext.SaveChanges();
            }
        }

        public IReadOnlyCollection<string> GetAllocationNumbersForApprovedContract(string contractNumber, int contractVersionNumber, int contractSubVersionNumber, ConnectionInfo connectionInfo)
        {
            using (ContractManagementDbContext context = new ContractManagementDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                return
                    _dbContext.ApprovedContractAllocations
                        .Where(aca => aca.ApprovedContract.ContractNumber == contractNumber &&
                                      aca.ApprovedContract.ContractVersionNumber == contractVersionNumber &&
                                      aca.ApprovedContract.ContractSubVersionNumber == contractSubVersionNumber)
                        .Select(aca => aca.ContractAllocationNumber).ToList();
            }
        }
    }
}
