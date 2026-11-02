namespace SFA.FCT.AllocationDelivery.DataStore.Model
{
    using System;
    using System.ComponentModel;
    using System.Reflection;
    public enum AllocationDeliveryEntryCategory
    {
        [Description("New Contract Allocation Approved")]
        NewContractAllocationApproved,
        [Description("Amended Contract Allocation Approved")]
        AmendedContractAllocationApproved,
        [Description("Contract Allocation Actuals Received")]
        ContractAllocationActualsReceived,
        [Description("Contract Allocation Payment Posted")]
        ContractAllocationPaymentReceived,
        [Description("Contract Allocation Actuals Updated")]
        ContractAllocationActualsUpdated
    }

    public static class EnumExtensions
    {
        public static string GetDescription(this Enum en)
        {
            Type type = en.GetType();
            MemberInfo[] memberInfo = type.GetMember(en.ToString());
            if (memberInfo.Length == 0)
                return en.ToString();

            object[] attrs = memberInfo[0].GetCustomAttributes(typeof(DescriptionAttribute), false);

            return attrs.Length > 0 ? ((DescriptionAttribute)attrs[0]).Description : en.ToString();
        }
    }
}
