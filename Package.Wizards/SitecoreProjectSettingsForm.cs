using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.IO;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Package.Wizards
{
    public partial class SitecoreProjectSettingsForm : Form
    {
        private readonly SitecoreProjectSettings _settings;
        private bool txtLicenseFileTouched = false;

        public SitecoreProjectSettingsForm(SitecoreProjectSettings settings)
        {
            _settings = settings;
            InitializeComponent();
        }

        private void uiBtnBrowseLicenseFile_Click(object sender, EventArgs e)
        {
            var result = uiOfdLicenseFile.ShowDialog();
            if (result == DialogResult.OK)
            {
                uiTxtLicenseFile.Text = uiOfdLicenseFile.FileName;
            }
        }

        private void uiTxtLicenseFile_TextChanged(object sender, EventArgs e)
        {
            txtLicenseFileTouched = true;
            _settings.LicenseFile = uiTxtLicenseFile.Text;
            ValidateChildren();
        }

        private void uiTxtLicenseFile_Validating(object sender, CancelEventArgs e)
        {
            if (!txtLicenseFileTouched)
            {
                return;
            }
            if (uiTxtLicenseFile.Text.Length == 0)
            {
                uiErrLicenseFile.Text = "Sitecore license file is required to create a project";
                SetErrorState(e);
            }
            else if (!uiTxtLicenseFile.Text.EndsWith(".xml") || !File.Exists(uiTxtLicenseFile.Text))
            {
                uiErrLicenseFile.Text = "Invalid license file, please correct the path";
                SetErrorState(e);
            }
            else
            {
                SetOkState(e);
            }
        }

        private void SetErrorState(CancelEventArgs e)
        {
            SetState(e, error: true);
        }

        private void SetOkState(CancelEventArgs e)
        {
            SetState(e, error: false);
        }

        private void SetState(CancelEventArgs e, bool error)
        {
            uiErrLicenseFile.Visible = error;
            uiBtnOk.Enabled = !error;
            e.Cancel = error;
        }
    }
}
