namespace SFA.FCT.Operations.Common.Extensions
{
    using System;

    public static class StringExtensions
    {
        public static string GetSubstringBeforeCharacter(this string text, string character)
        {
            int indexOfCharacter = text.IndexOf(character, StringComparison.Ordinal);

            if (indexOfCharacter != -1)
            {
                return text.Substring(0, indexOfCharacter);
            }
           
            throw new ArgumentException($"The character {character} is not contained in the text {text}");
        }
    }
}
