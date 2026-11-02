namespace PerformanceManagementDomain.Extensions
{
    using System;
    using System.ComponentModel;
    using System.Reflection;

    public static class EnumExtensions
    {
        public static string GetDescription(this Enum enumInstance)
        {
            Type type = enumInstance.GetType();
            MemberInfo[] memberInfo = type.GetMember(enumInstance.ToString());

            if (memberInfo.Length == 0)
            {
                return enumInstance.ToString();
            }

            object[] attrs = memberInfo[0].GetCustomAttributes(typeof(DescriptionAttribute), false);

            return attrs.Length > 0 ? ((DescriptionAttribute)attrs[0]).Description : enumInstance.ToString();
        }
    }
}
