using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ADMonitoringDomain.DataStore.Model;
using SFA.FCT.CrossDomain.Integration.Common;
using SFA.FCT.CrossDomain.Integration.Events;

namespace ADMonitoringDomain.Endpoint.BusinessLogic.EventExtensions
{
    public static class IPaymentScheduleEventExtensions
    {
        public static AllocationDeliveryEventReceived ToAllocationDeliveryEventReceived(this PaymentScheduleEvent pse, IDate dateService, string category = "")
        {
            return new AllocationDeliveryEventReceived()
            {
                AllocationNumber = pse.PaymentScheduleAllocation.AllocationNumber,
                CategoryName = category,
                EventName = pse.GetType().Name,
                EventReceived = dateService.GetCalculationDate(),
                VersionNumber = pse.PaymentScheduleAllocation.ContractVersionNumber,
                Object = pse,
                ObjectType = pse.GetType().AssemblyQualifiedName
            };
        }
    }
}
