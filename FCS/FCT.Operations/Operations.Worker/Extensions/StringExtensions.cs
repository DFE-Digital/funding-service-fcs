namespace Operations.Worker.Extensions
{
    using System.Collections.Generic;
    using System.Linq;

    public static class StringExtensions
    {
        public static bool IsEmpty(this string text)
        {
            return string.IsNullOrEmpty(text);
        }

        public static string CleanOddCharsFromJson(this string jsonString)
        {
            const char byteOrderMark = '\uFEFF';
            const char zeroWidthSpace = '\u200B';
            const char leftCurly = '{';

            List<string> oddStrings = new List<string>
            {
                "�\u0002",
                "@\fbase64Binary\b3http://schemas.microsoft.com/2003/10/Serialization/�'",
                "@base64Binary3http://schemas.microsoft.com/2003/10/Serialization/�{",
                "�\u0001",
                "\u0003",
            };

            oddStrings.ForEach(oddString =>
            {
                jsonString = jsonString.Replace(oddString, string.Empty).Replace(" ", string.Empty);
            });

            char[] extraCurly = { leftCurly, byteOrderMark, leftCurly };
            // we occasionally see this double curly at the beginning
            if (jsonString.Length > 2)
            {
                var firstThreeChars = jsonString.Substring(0, 3).ToCharArray();
                if (extraCurly.SequenceEqual(firstThreeChars))
                {
                    jsonString = jsonString.Substring(2);
                }
            }
            
            return jsonString.Trim(new char[] { byteOrderMark, zeroWidthSpace });
        }
    }
}