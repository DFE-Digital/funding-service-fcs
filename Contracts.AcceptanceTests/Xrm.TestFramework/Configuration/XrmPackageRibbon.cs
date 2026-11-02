// <copyright file="XrmPackageRibbon.cs" company="Ciber">
//     Company Copyright
// </copyright>
namespace SFA.FCT.Xrm.TestFramework
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Xml;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    // Using statements for Assertions
    
    /// -----------------------------------------------------------------
    ///   Namespace:      Ciber.Xrm.Tests.MetaData
    ///   Class:          XrmPackageRibbon
    ///   Description:    Class for handling the RibbonDiffXml for an entity form as defined by a Dynamics CRM Solution
    ///   Notes:          
    ///   Author:         Ben Bartle    
    /// -----------------------------------------------------------------
    /// <summary> 
    /// Class for handling the RibbonDiffXml for an entity form as defined by a Dynamics CRM Solution
    /// </summary>
    public class XrmPackageRibbon
    {
        #region Fields

        /// <summary>
        /// Dictionary holding buttons and their enabled status
        /// </summary>
        private Dictionary<string, bool> buttonsEnabled;

        #endregion

        #region Constructors

        /// <summary>
        /// Initializes a new instance of the <see cref="XrmPackageRibbon"/> class
        /// </summary>
        /// <param name="ribbonFilePath"></param>
        public XrmPackageRibbon(string ribbonFilePath, string entityLogicalName, XrmRibbonType xrmRibbonType)
        {
            // Open document
            XmlDocument xmlDocument = new XmlDocument();
            xmlDocument.Load(ribbonFilePath);

            this.RibbonType = xrmRibbonType;

            Dictionary<string, bool> buttons = new Dictionary<string, bool>();

            // Load Ribbon Buttons
            foreach (XmlNode f in xmlDocument.SelectNodes(".//HideCustomAction[contains(@Location,\"" + xrmRibbonType.ToDescription() + "\")]"))
            {
                string locationString = XrmPackageRibbon.ParseButton(f.Attributes["Location"].Value, entityLogicalName, xrmRibbonType);
                buttons.Add(locationString, false);
            }

            this.buttonsEnabled = buttons;
        }

        #endregion

        #region Properties

        /// <summary>
        /// Gets a value indicating the ribbon type
        /// </summary>
        public XrmRibbonType RibbonType { get; private set; }

        #endregion

        #region Methods

        /// <summary>
        /// Parses a button location from the RibbonDiffXml
        /// </summary>
        /// <param name="locationString">The location string from the HideCustomAction element from the RibbonDiff.xml</param>
        /// <param name="entityLogicalName">The logical name for the entity</param>
        /// <param name="ribbonLocation">The location XrmRibbonType to be parsed</param>
        /// <returns></returns>
        private static string ParseButton(string locationString, string entityLogicalName, XrmRibbonType ribbonLocation)
        {
            string stripLocation = locationString.Replace("Mscrm." + ribbonLocation.ToDescription() + "." + entityLogicalName + ".", string.Empty);
            return stripLocation;
        }

        /// <summary>
        /// Verifies that the specified button is hidden in the ribbon
        /// </summary>
        /// <param name="button">The button command</param>
        /// <returns>An instance of itself</returns>
        public XrmPackageRibbon IsButtonHidden(XrmRibbonButton button)
        {
            var ribbonMatch = from b in this.buttonsEnabled where (b.Key == button.ToDescription()) select b;

            Assert.IsTrue(ribbonMatch.Count() > 0, "The button: " + button.ToDescription() + " is not on the CRM ribbon");

            Assert.IsTrue(ribbonMatch.First().Value == false, "The button: " + button.ToDescription() + " is not hidden");

            return this;
        }

        #endregion
    }
}