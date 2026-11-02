namespace SFA.FCT.Contracts.AcceptanceTests.Extensions
{
    using System;

    public static class EnumExtensions
    {
        public static bool IsEquivalentWithFirstValueEqualityToNull<T>(this T a, T? b) where T : struct
        {
            return a.Equals(b) || (a.Equals(default(T)) && b == null);
        }

        public static string GetEnumValueAsStringOrDefault<T>(this int intValue, string defaultStr) where T : struct
        {
            if (Enum.IsDefined(typeof(T), intValue))
            {
                return Enum.GetName(typeof(T), intValue);
            }

            return defaultStr;
        }
    }
}
