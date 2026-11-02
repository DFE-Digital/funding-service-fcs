namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.Deliverable.Utils
{
    using System.Linq;
    using CrossDomain.Integration.Entities;
    using CrossDomain.Integration.Entities.ContractRequest;

    public static class DeliverableUtils
    {
        public static string GetDeliverablePlanningUnit(FSCDeliverableStructureDefinitionResponse deliverableStructureDefinition, contractDeliverable deliverable)
        {
            if (deliverableStructureDefinition != null)
            {
                var structureData =
                    deliverableStructureDefinition.DeliverableStructureList.FirstOrDefault(
                        d => d.DeliverableCode == deliverable.deliverable.deliverableCode);

                if (structureData != null)
                {
                    var setting = structureData.Settings.FirstOrDefault(s => s.SettingCode.Contains("planningunit"));
                    if (setting != null)
                    {
                        return setting.SettingValue;
                    }
                }
            }

            return "Invalid";
        }

        public static bool CheckDeliverableAllowsProfile(FSCDeliverableStructureDefinitionResponse deliverableStructureDefinition, contractDeliverable deliverable)
        {
            if (deliverableStructureDefinition != null)
            {
                var structureData =
                    deliverableStructureDefinition.DeliverableStructureList
                    .FirstOrDefault(d => d.DeliverableCode == deliverable.deliverable.deliverableCode);

                if (structureData != null)
                {
                    var setting = structureData.Settings.FirstOrDefault(s => s.SettingCode.Contains("allowprofile"));
                    if (setting != null)
                    {
                        return setting.SettingValue == "Yes";
                    }
                }
            }

            return true;
        }

        public static bool IsValidDeliverableForFundingStreamPeriod(FSCDeliverableStructureDefinitionResponse deliverableStructureDefinition, contractDeliverable deliverable)
        {
            if (deliverableStructureDefinition == null)
            {
                return false;
            }

            return 
                deliverableStructureDefinition.DeliverableStructureList.Exists(
                    d => d.DeliverableCode == deliverable.deliverable.deliverableCode);
        }
    }
}