namespace SFA.FCT.Contracts.AcceptanceTests.Extensions
{
    using System;
    using Microsoft.Xrm.Sdk;

    public static class OptionSetValueExtensions
    {
        public static string GetName<T>(this OptionSetValue optionSetValue)
        {
            if (optionSetValue != null)
            {
                return Enum.GetName(typeof(T), optionSetValue.Value);
            }

            return null;
        }
    }
}
