namespace Datafix.Tests.Extensions
{
    using System;
    using System.Linq;

    public static class StringExtensions
    {
        public static bool IsAllUpperCase(this string text)
        {
            if (!string.IsNullOrEmpty(text))
            {
                text = text.Trim();

                return text == text.ToUpper();
            }

            return false;
        }

        public static string ToPascalCase(this string text)
        {
            if (!string.IsNullOrEmpty(text))
            {
                var words = text.Split(' ');

                string ToPascalWord(string t)
                {
                    string firstCharacterAsUpper = t.Substring(0, 1).ToUpper();

                    string restOfStringAsLower = t.Substring(1).ToLower();

                    return $"{firstCharacterAsUpper}{restOfStringAsLower}";
                }

                var pascalWords = words.Select(ToPascalWord);

                return string.Join(" ", pascalWords);
            }

            return text;
        }

        public static bool HasUpperCaseAfterApostropheMistake(this string text)
        {
            if (!string.IsNullOrEmpty(text))
            {
                int indexOfApostrophe = text.IndexOf("'", StringComparison.Ordinal);

                if (indexOfApostrophe != -1 && text.Length > indexOfApostrophe + 1)
                {
                    string charactersAfterApostrophe = text.Substring(indexOfApostrophe + 1);

                    return charactersAfterApostrophe.Length > 0 
                           && charactersAfterApostrophe.IsFirstCharacterUpperCase()
                           && charactersAfterApostrophe.IsSecondCharacterASpaceOrEndOfString();
                }
            }

            return false;
        }

        public static string ChangeCharacterAfterApostropheToLower(this string text)
        {
            if (!string.IsNullOrEmpty(text))
            {
                int indexOfApostrophe = text.IndexOf("'", StringComparison.Ordinal);

                if (indexOfApostrophe != -1 && text.Length > indexOfApostrophe + 1)
                {
                    string upToIncludingApostrophe = text.Substring(0, indexOfApostrophe + 1);

                    string characterAfterApostrophe = text.Substring(indexOfApostrophe + 1, 1).ToLower();

                    string remainingString = string.Empty;
                    if (text.Length > indexOfApostrophe + 2)
                    {
                        remainingString = text.Substring(indexOfApostrophe + 2);
                    }

                    return $"{upToIncludingApostrophe}{characterAfterApostrophe}{remainingString}";
                }
            }

            return text;
        }

        private static bool IsFirstCharacterUpperCase(this string text)
        {
            return text.Substring(0, 1).IsAllUpperCase();
        }

        private static bool IsSecondCharacterASpaceOrEndOfString(this string text)
        {
            return text.Length == 1 || text.Substring(1, 1) == " ";
        }
    }
}
