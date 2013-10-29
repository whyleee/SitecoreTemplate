namespace Package.Wizards
{
    partial class SitecoreProjectSettingsForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.uiLblLicenseFile = new System.Windows.Forms.Label();
            this.uiOfdLicenseFile = new System.Windows.Forms.OpenFileDialog();
            this.uiTxtLicenseFile = new System.Windows.Forms.TextBox();
            this.uiBtnBrowseLicenseFile = new System.Windows.Forms.Button();
            this.uiBtnOk = new System.Windows.Forms.Button();
            this.uiBtnCancel = new System.Windows.Forms.Button();
            this.uiErrLicenseFile = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // uiLblLicenseFile
            // 
            this.uiLblLicenseFile.AutoSize = true;
            this.uiLblLicenseFile.Location = new System.Drawing.Point(13, 13);
            this.uiLblLicenseFile.Name = "uiLblLicenseFile";
            this.uiLblLicenseFile.Size = new System.Drawing.Size(280, 13);
            this.uiLblLicenseFile.TabIndex = 0;
            this.uiLblLicenseFile.Text = "Select Sitecore 7 CMS license file to use with the website:";
            // 
            // uiTxtLicenseFile
            // 
            this.uiTxtLicenseFile.Location = new System.Drawing.Point(16, 40);
            this.uiTxtLicenseFile.Name = "uiTxtLicenseFile";
            this.uiTxtLicenseFile.Size = new System.Drawing.Size(348, 20);
            this.uiTxtLicenseFile.TabIndex = 1;
            this.uiTxtLicenseFile.TextChanged += new System.EventHandler(this.uiTxtLicenseFile_TextChanged);
            this.uiTxtLicenseFile.Validating += new System.ComponentModel.CancelEventHandler(this.uiTxtLicenseFile_Validating);
            // 
            // uiBtnBrowseLicenseFile
            // 
            this.uiBtnBrowseLicenseFile.Location = new System.Drawing.Point(370, 38);
            this.uiBtnBrowseLicenseFile.Name = "uiBtnBrowseLicenseFile";
            this.uiBtnBrowseLicenseFile.Size = new System.Drawing.Size(75, 23);
            this.uiBtnBrowseLicenseFile.TabIndex = 2;
            this.uiBtnBrowseLicenseFile.Text = "Browse...";
            this.uiBtnBrowseLicenseFile.UseVisualStyleBackColor = true;
            this.uiBtnBrowseLicenseFile.Click += new System.EventHandler(this.uiBtnBrowseLicenseFile_Click);
            // 
            // uiBtnOk
            // 
            this.uiBtnOk.DialogResult = System.Windows.Forms.DialogResult.OK;
            this.uiBtnOk.Enabled = false;
            this.uiBtnOk.Location = new System.Drawing.Point(289, 98);
            this.uiBtnOk.Name = "uiBtnOk";
            this.uiBtnOk.Size = new System.Drawing.Size(75, 23);
            this.uiBtnOk.TabIndex = 3;
            this.uiBtnOk.Text = "OK";
            this.uiBtnOk.UseVisualStyleBackColor = true;
            // 
            // uiBtnCancel
            // 
            this.uiBtnCancel.CausesValidation = false;
            this.uiBtnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel;
            this.uiBtnCancel.Location = new System.Drawing.Point(370, 98);
            this.uiBtnCancel.Name = "uiBtnCancel";
            this.uiBtnCancel.Size = new System.Drawing.Size(75, 23);
            this.uiBtnCancel.TabIndex = 4;
            this.uiBtnCancel.Text = "Cancel";
            this.uiBtnCancel.UseVisualStyleBackColor = true;
            // 
            // uiErrLicenseFile
            // 
            this.uiErrLicenseFile.AutoSize = true;
            this.uiErrLicenseFile.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(192)))), ((int)(((byte)(0)))), ((int)(((byte)(0)))));
            this.uiErrLicenseFile.Location = new System.Drawing.Point(16, 67);
            this.uiErrLicenseFile.Name = "uiErrLicenseFile";
            this.uiErrLicenseFile.Size = new System.Drawing.Size(90, 13);
            this.uiErrLicenseFile.TabIndex = 5;
            this.uiErrLicenseFile.Text = "[License file error]";
            this.uiErrLicenseFile.Visible = false;
            // 
            // SitecoreProjectSettingsForm
            // 
            this.AcceptButton = this.uiBtnOk;
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.AutoValidate = System.Windows.Forms.AutoValidate.EnableAllowFocusChange;
            this.CancelButton = this.uiBtnCancel;
            this.ClientSize = new System.Drawing.Size(457, 133);
            this.Controls.Add(this.uiErrLicenseFile);
            this.Controls.Add(this.uiBtnCancel);
            this.Controls.Add(this.uiBtnOk);
            this.Controls.Add(this.uiBtnBrowseLicenseFile);
            this.Controls.Add(this.uiTxtLicenseFile);
            this.Controls.Add(this.uiLblLicenseFile);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "SitecoreProjectSettingsForm";
            this.ShowIcon = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "New Sitecore 7 CMS Project";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label uiLblLicenseFile;
        private System.Windows.Forms.OpenFileDialog uiOfdLicenseFile;
        private System.Windows.Forms.TextBox uiTxtLicenseFile;
        private System.Windows.Forms.Button uiBtnBrowseLicenseFile;
        private System.Windows.Forms.Button uiBtnOk;
        private System.Windows.Forms.Button uiBtnCancel;
        private System.Windows.Forms.Label uiErrLicenseFile;
    }
}