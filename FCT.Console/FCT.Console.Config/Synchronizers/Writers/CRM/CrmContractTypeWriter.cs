namespace FCT.Console.Config.Synchronizers.Writers.CRM
{
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    public class CrmContractTypeWriter : CrmConfigWriter<ContractTypeSheetType, sfa_contracttype>
    {
        protected override void UpdateMatchingEntity(ContractTypeSheetType row, sfa_contracttype matchingEntity)
        {
            matchingEntity.sfa_name = row.ContractType;
        }

        protected override sfa_contracttype CreateEntity(ContractTypeSheetType row)
        {
            sfa_contracttype contractType = new sfa_contracttype
            {
                sfa_name = row.ContractType
            };

            return contractType;
        }

        protected override IEnumerable<sfa_contracttype> GetMatchingEntities(XrmServiceContext crmContext, ContractTypeSheetType row)
        {
            return crmContext.sfa_contracttypeSet.Where(ct => ct.sfa_name == row.ContractType).ToList();
        }
    }
}