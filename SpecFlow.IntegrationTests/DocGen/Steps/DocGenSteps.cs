namespace DocGenTests.Steps
{
    using System.Linq;
    using Infrastructure;
    using NUnit.Framework;
    // using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using TechTalk.SpecFlow;

    [Binding]
    public class DocGenSteps
    {
        [Given(@"the following state parameters")]
        public void GivenTheFollowingStateParameters(Table table)
        {
            table.Rows.ToList().ForEach(r =>
            {
                string paramName = r["ParamName"].Replace("[", "").Replace("]", "");
                string paramValue = r["ParamValue"];

                FeatureVariables.Set(paramName, paramValue);
            });
        }

        [When(@"we pass '(.*)' to doc gen")]
        public void WhenWePassToDocGen(string relativeFileName)
        {
            DocumentGenerationCommand documentGenerationCommand = DocumentGenerationCommandCreator.ToDocumentGenerationCommand(relativeFileName);

            Assert.IsNotNull("The doc gen command is null");
        }

        [Then(@"the contents of the file look like this")]
        public void ThenTheContentsOfTheFileLookLikeThis(string multilineText)
        {
            
        }

    }
}
