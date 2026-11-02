namespace ContractManagementService.Extensions
{
    public static class StringExtensions
    {
        public static int? ToInt(this string intVal)
        {
            if (!string.IsNullOrEmpty(intVal))
            {
                return int.Parse(intVal);
            }

            return null;
        }

        public static bool HasValue(this string text)
        {
            return !string.IsNullOrEmpty(text);
        }
    }
}
