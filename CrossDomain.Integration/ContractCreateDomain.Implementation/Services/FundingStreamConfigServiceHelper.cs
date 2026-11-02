namespace SFA.FCT.ContractCreateDomain.Implementation.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities;

    public static class FundingStreamConfigServiceHelper
    {
        public static FSCDeliverableStructureDefinitionResponse FilterProfileDeliverableStructure(FSCDeliverableStructureDefinitionResponse deliverableStructure)
        {
            var itemsToKeep = new List<DeliverableConfigurationType>();

            DetermineItemsToKeep(deliverableStructure, itemsToKeep);

            // Now put back in order, incase it is important
            deliverableStructure.DeliverableStructureList.Clear();

            deliverableStructure.DeliverableStructureList.AddRange(itemsToKeep.OrderBy(d => d.DeliverableCode));

            return deliverableStructure;
        }

        private static void DetermineItemsToKeep(FSCDeliverableStructureDefinitionResponse deliverableStructure, List<DeliverableConfigurationType> itemsToKeep)
        {
            foreach (var deliverable in deliverableStructure.DeliverableStructureList)
            {
                // copy any profile deliverables
                if (deliverable.Settings.Any(m => m.SettingCode.Contains("allowprofile") && m.SettingValue == "Yes"))
                {
                    itemsToKeep.Add(deliverable);

                    IterateParent(deliverable, deliverableStructure, itemsToKeep);
                }
            }
        }

        private static void IterateParent(DeliverableConfigurationType deliverable, FSCDeliverableStructureDefinitionResponse deliverableStructure, List<DeliverableConfigurationType> itemsToKeep)
        {
            // make this recursive
            if (deliverable.ParentDetails != null && deliverable.ParentDetails.ParentDeliverableCode != null)
            {
                foreach (var parent in deliverableStructure.DeliverableStructureList.Where(d => d.DeliverableCode.Equals(deliverable.ParentDetails.ParentDeliverableCode)))
                {
                    if (!itemsToKeep.Contains(parent))
                    {
                        itemsToKeep.Add(parent);

                        IterateParent(parent, deliverableStructure, itemsToKeep);
                    }
                }
            }
        }
    }
}