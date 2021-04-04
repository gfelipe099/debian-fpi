#include <gtk/gtk.h>

typedef struct {
    GtkWidget       *about_dialog_box;
    GtkWidget       *settings_box;
} app_widgets;

int main(int argc, char *argv[]) {
    GtkBuilder      *root;
    GtkBuilder      *about;
    GtkBuilder      *settings;
    GtkWidget       *window;
    app_widgets     *widgets = g_slice_new(app_widgets);

    gtk_init(&argc, &argv);

    root = gtk_builder_new_from_file("gui/root.glade");
    about = gtk_builder_new_from_file("gui/about.glade");
    settings = gtk_builder_new_from_file("gui/settings.glade");
    window = GTK_WIDGET(gtk_builder_get_object(root, "root"));

    widgets->about_dialog_box = GTK_WIDGET(gtk_builder_get_object(about, "about"));
    widgets->settings_box = GTK_WIDGET(gtk_builder_get_object(settings, "settings"));

    gtk_builder_connect_signals(root, widgets);

    g_object_unref(root);

    gtk_widget_show(window);
    gtk_main();
    g_slice_free(app_widgets, widgets);

    return 0;
}

// Main buttons
void on_Check_kernel_version_clicked() {
    system("sh -c 'echo Operation system: $(lsb_release -ds); echo Kernel version in use: $(uname -r)'");
}

//////// Menu bar buttons //////// 
// File > Quit
void on_about_dialog_quit_activate(GtkMenuItem *menuitem, app_widgets *widgets) {
    gtk_main_quit();
}

// Help > About button
void on_About_activate(GtkMenuItem *menuitem, app_widgets *widgets) {
    gtk_widget_show(widgets->about_dialog_box);
}

// Settings button
void on_Settings_btn_select(GtkWidget *menuitem, app_widgets *widgets) {
    gtk_widget_show(widgets->settings_box);
}

// When window is closed
void on_window_main_destroy() {
    gtk_main_quit();
}

//////// Buttons ////////

//// GNOME ////
void on_Install_basic_tools_gnome_clicked() {
    system("sh -c 'apt-get install -y nautilus gnome-terminal gedit clamtk-gnome'");
}

void on_Install_system_tools_gnome_clicked() {
    system("sh -c 'apt-get install -y selinux-basics selinux-policy-default gufw clamtk gcc make firmware-linux-free curl linux-headers-$(uname -r) gdebi fonts-noto-color-emoji'");
}

void on_Install_extras_gnome_clicked() {
    system("sh -c 'apt-get install -y firefox-esr libreoffice gimp'");
}

//// KDE ////
void on_Install_basic_tools_kde_clicked() {
    system("sh -c 'apt-get install -y plasma-nm dolphin konsole kate kwin-{x11,wayland}'");
}

void on_Install_system_tools_kde_clicked() {
    system("sh -c 'apt-get install -y selinux-basics selinux-policy-default gufw clamtk gcc make firmware-linux-free curl linux-headers-$(uname -r) gdebi fonts-noto-color-emoji'");
}

void on_Install_extras_kde_clicked() {
    system("sh -c 'apt-get install -y firefox-esr libreoffice gimp'");
}

//// XFCE ////
void on_Install_basic_tools_xfce_clicked() {
    system("sh -c 'apt-get install -y thunar mousepad ristretto xfce4-{screenshooter,terminal,goodies,themes}'");
}

void on_Install_system_tools_xfce_clicked() {
    system("sh -c 'apt-get install -y selinux-basics selinux-policy-default gufw clamtk gcc make firmware-linux-free curl linux-headers-$(uname -r) gdebi fonts-noto-color-emoji'");
}

void on_Install_extras_xfce_clicked() {
    system("sh -c 'apt-get install -y firefox-esr libreoffice gimp'");
}
