namespace FCT.Operations.PaymentSummary.Extensions
{
    using System.Linq;
    public static class IntExtensions
    {
        private static char[] Alphabet => Enumerable.Range('A', 26).Select(i => (char)i).ToArray();

        public static string GetExcelColumnName(this int index)
        {
            var indexStartingFromOne = (index + 1);
            int firstCharIndex = indexStartingFromOne / Alphabet.Length;
            int remainder = indexStartingFromOne % Alphabet.Length;

            if (firstCharIndex == 0 || firstCharIndex == 1 && remainder == 0)
            {
                return Alphabet[index].ToString();
            }

            if (remainder != 0)
            {
                remainder -= 1; // return to zero number base
                firstCharIndex -= 1;
            }
            else
            {
                firstCharIndex -= 2;
                remainder = 25;
            }

            return $"{Alphabet[firstCharIndex]}{Alphabet[remainder]}";
        }
    }
}
