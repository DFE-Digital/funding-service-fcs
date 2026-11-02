namespace Datafix.Tests.Extensions
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class StringExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void StringExtensions_HasUpperCaseAfterApostropheMistake_ShouldReturnTrueForPoorString()
        {
            // arrange
            const string unsanitizedText = "King'S Lynn";

            // act
            bool isWrong = unsanitizedText.HasUpperCaseAfterApostropheMistake();
            
            // assert
            Assert.IsTrue(isWrong);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void StringExtensions_HasUpperCaseAfterApostropheMistake_ShouldReturnFalseForGoodString()
        {
            // arrange
            const string unsanitizedText = "O'Neill";

            // act
            bool isWrong = unsanitizedText.HasUpperCaseAfterApostropheMistake();

            // assert
            Assert.IsFalse(isWrong);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void StringExtensions_HasUpperCaseAfterApostropheMistake_ShouldReturnFalseForGoodString2()
        {
            // arrange
            const string unsanitizedText = "23 Cross O'Cliff Hill";

            // act
            bool isWrong = unsanitizedText.HasUpperCaseAfterApostropheMistake();

            // assert
            Assert.IsFalse(isWrong);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void StringExtensions_HasUpperCaseAfterApostropheMistake_ShouldReturnFalseForGoodString3()
        {
            // arrange
            const string unsanitizedText = "John O'Gaunts Way";

            // act
            bool isWrong = unsanitizedText.HasUpperCaseAfterApostropheMistake();

            // assert
            Assert.IsFalse(isWrong);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void StringExtensions_HasUpperCaseAfterApostropheMistake_ShouldReturnFalseForGoodStringPossessive()
        {
            // arrange
            const string unsanitizedText = "Bill's";

            // act
            bool isWrong = unsanitizedText.HasUpperCaseAfterApostropheMistake();

            // assert
            Assert.IsFalse(isWrong);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void StringExtensions_HasUpperCaseAfterApostropheMistake_ShouldReturnTrueForBadStringPossessive()
        {
            // arrange
            const string unsanitizedText = "Bill'S";

            // act
            bool isWrong = unsanitizedText.HasUpperCaseAfterApostropheMistake();

            // assert
            Assert.IsTrue(isWrong);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void StringExtensions_ChangeCharacterAfterApostropheToLower_ShouldChangePoorTextUpperCaseAtTheEnd()
        {
            // arrange
            const string unsanitizedText = "Bill'S";

            // act
            string sanitized = unsanitizedText.ChangeCharacterAfterApostropheToLower();

            // assert
            Assert.AreEqual("Bill's", sanitized);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void StringExtensions_ChangeCharacterAfterApostropheToLower_ShouldChangePoorTextUpperCaseInTheMiddle()
        {
            // arrange
            const string unsanitizedText = "King'S Lynn";

            // act
            string sanitized = unsanitizedText.ChangeCharacterAfterApostropheToLower();

            // assert
            Assert.AreEqual("King's Lynn", sanitized);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void StringExtensions_ChangeCharacterAfterApostropheToLower_ShouldNotChangeGoodTextWithApostrophe()
        {
            // arrange
            const string unsanitizedText = "King's Lynn";

            // act
            string sanitized = unsanitizedText.ChangeCharacterAfterApostropheToLower();

            // assert
            Assert.AreEqual("King's Lynn", sanitized);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void StringExtensions_ChangeCharacterAfterApostropheToLower_ShouldNotChangeGoodTextWithNoApostrophe()
        {
            // arrange
            const string unsanitizedText = "King James";

            // act
            string sanitized = unsanitizedText.ChangeCharacterAfterApostropheToLower();

            // assert
            Assert.AreEqual(unsanitizedText, sanitized);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void StringExtensions_ToPascalCase_ShouldChangeUpperCaseToPascalOneWord()
        {
            // arrange
            const string unsanitizedText = "KING";

            // act
            string sanitized = unsanitizedText.ToPascalCase();

            // assert
            Assert.AreEqual("King", sanitized);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void StringExtensions_ToPascalCase_ShouldChangeUpperCaseToPascalTwoWord()
        {
            // arrange
            const string unsanitizedText = "KING JAMES";

            // act
            string sanitized = unsanitizedText.ToPascalCase();

            // assert
            Assert.AreEqual("King James", sanitized);
        }
    }
}
