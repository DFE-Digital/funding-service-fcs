////namespace SFA.FCT.ContractCreateDomain.Implementation.Persistence
////{
////    using System;
////    using System.Linq;
////    using CrossDomain.Integration.Entities.Xrm;
////    using CrossDomain.Integration.Entities.Xrm.OptionSets;
////    using Microsoft.Xrm.Sdk;
    
////    public class XrmContractManager : IXrmContractManager
////    {
////        public IOrganizationService OrganizationService { get; set; }

////        public IContractsManager contractsManager { get; set; }

////        public void SeedApprovedContracts(DateTime since)
////        {
////            // get list of contracts approved since parameter date
////            using (var xrmContext = new XrmServiceContext(OrganizationService))
////            {
////                var contractsListQuery = from c in xrmContext.sfa_contractSet
////                    where c.sfa_HierarchyTypeEnum.Equals(sfa_contracthierarchytype.Contract)
////                    where c.sfa_ContractStatusEnum.Equals(sfa_contractstatus.Approved)
////                    where c.sfa_LastApprovedVersion.Equals(true)
////                    where c.ModifiedOn.Value >= since
////                    orderby c.ModifiedOn.Value
////                    select new
////                    {
////                        Id = c.Id,
////                        contractNumber = c.sfa_number,
////                        masterContractNumber = c.sfa_ParentContractId.Name
////                    };

////                var contracts = contractsListQuery.ToList();

////                foreach (var contract in contracts)
////                {

////                    var cc = contractsManager.GetCorporateContract(contract.contractNumber, contract.masterContractNumber);

////                }
////            }
////        }
////    }
////}