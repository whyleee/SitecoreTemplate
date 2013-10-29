using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using EnvDTE;
using Microsoft.VisualStudio.TemplateWizard;

namespace Package.Wizards
{
    public class SitecoreProjectSettingsWizard : IWizard
    {
        private readonly SitecoreProjectSettings _settings = new SitecoreProjectSettings();
        private DTE _dte;

        public void RunStarted(
            object automationObject,
            Dictionary<string, string> replacementsDictionary,
            WizardRunKind runKind,
            object[] customParams)
        {
            _dte = (DTE) automationObject;

            try
            {
                var form = new SitecoreProjectSettingsForm(_settings);
                var result = form.ShowDialog();

                if (result != DialogResult.OK)
                {
                    try
                    {
                        var projectDirPath = replacementsDictionary["$destinationdirectory$"];
                        var parentDir = Directory.GetParent(projectDirPath);
                        var solutionPath = parentDir != null ? parentDir.FullName : projectDirPath;
                        Directory.Delete(solutionPath, recursive: true);
                    }
                    catch (IOException) {}

                    _dte.StatusBar.Clear();
                    _dte.Solution.Close();

                    throw new WizardBackoutException();
                }
            }
            catch (WizardBackoutException)
            {
                throw;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString());
            }
        }

        public void ProjectFinishedGenerating(Project project)
        {
            // Copy selected license file to the data dir
            var dataDir = Path.Combine(Path.GetDirectoryName(project.FullName), "App_Data");
            var targetLicensePath = Path.Combine(dataDir, "license.xml");

            Directory.CreateDirectory(dataDir);
            File.Copy(_settings.LicenseFile, targetLicensePath);
        }

        // Not used
        public void ProjectItemFinishedGenerating(ProjectItem projectItem) {}
        public bool ShouldAddProjectItem(string filePath) {return true;}
        public void BeforeOpeningFile(ProjectItem projectItem) {}
        public void RunFinished() {}
    }
}
