# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.5

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/ivo/ubtouchApps/kaltracker

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/ivo/ubtouchApps/kaltracker/build/all/app

# Utility rule file for kaltracker.ivoxavier.pot.

# Include the progress variables for this target.
include po/CMakeFiles/kaltracker.ivoxavier.pot.dir/progress.make

po/CMakeFiles/kaltracker.ivoxavier.pot:
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --blue --bold --progress-dir=/home/ivo/ubtouchApps/kaltracker/build/all/app/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Generating translation template"
	cd /home/ivo/ubtouchApps/kaltracker/build/all/app/po && /usr/bin/intltool-extract --update --type=gettext/ini --srcdir=/home/ivo/ubtouchApps/kaltracker kaltracker.desktop.in
	cd /home/ivo/ubtouchApps/kaltracker/build/all/app/po && /usr/bin/xgettext -o kaltracker.ivoxavier.pot -D /home/ivo/ubtouchApps/kaltracker/po -D /home/ivo/ubtouchApps/kaltracker/build/all/app/po --from-code=UTF-8 --c++ --qt --language=javascript --add-comments=TRANSLATORS --keyword=tr --keyword=tr:1,2 --keyword=ctr:1c,2 --keyword=dctr:2c,3 --keyword=N_ --keyword=_ --keyword=dtr:2 --keyword=dtr:2,3 --keyword=tag --keyword=tag:1c,2 --package-name='kaltracker.ivoxavier' --sort-by-file ../qml/Main.qml ../qml/Components/DeleteMonthDBPop.qml ../qml/Components/MaintenancePage.qml ../qml/Components/CreateTablesDialog.qml ../qml/Components/WelcomePage.qml ../qml/Components/UserFoodsListEditPage.qml ../qml/Components/AdviceIndexexDialog.qml ../qml/Components/ScheduleIngestionPage.qml ../qml/Components/UserListIngestionPage.qml ../qml/Components/ConfigUserProfilePage.qml ../qml/Components/ResumePage.qml ../qml/Components/CreateUserListPage.qml ../qml/Components/IndexesCalcPage.qml ../qml/Components/AboutDialog.qml ../qml/Components/StatsPage.qml ../qml/Components/ListModel/FoodsDrinks.qml ../qml/Components/ListModel/UserFoodsDrinks.qml ../qml/Components/AverageCaloriesMonthPage.qml ../qml/Components/ActionBar/AboutAction.qml ../qml/Components/ActionBar/HelpUserConfigAction.qml ../qml/Components/NewIngestionPage.qml ../qml/Components/UserAccountPage.qml ../qml/Components/ExportDataPage.qml ../qml/Components/AlertDialog.qml ../qml/Components/HelpUserConfigDialog.qml ../qml/Components/ConsumeHabitsPage.qml ../qml/Components/UpdateIngestionTimePop.qml ../qml/Components/FoodsTemplate.qml ../qml/Components/UpdateUserDetailsDialog.qml ../qml/Components/MonthIngestionsPage.qml ../qml/Components/UiAddOns/ListItemHeader.qml ../qml/Components/AlertsPage.qml ../qml/Components/SaveDataDialog.qml ../qml/Components/SettingsPage.qml ../qml/Components/RemoveRecordsDialog.qml ../qml/js/Bmi.js ../qml/js/KaloriesCalculator.js ../qml/js/AwarenessAnalysis.js ../qml/js/UserFoodsListDB.js ../qml/js/DataBaseTools.js ../qml/js/Ibw.js kaltracker.desktop.in.h
	cd /home/ivo/ubtouchApps/kaltracker/build/all/app/po && /usr/bin/cmake -E copy kaltracker.ivoxavier.pot /home/ivo/ubtouchApps/kaltracker/po

kaltracker.ivoxavier.pot: po/CMakeFiles/kaltracker.ivoxavier.pot
kaltracker.ivoxavier.pot: po/CMakeFiles/kaltracker.ivoxavier.pot.dir/build.make

.PHONY : kaltracker.ivoxavier.pot

# Rule to build all files generated by this target.
po/CMakeFiles/kaltracker.ivoxavier.pot.dir/build: kaltracker.ivoxavier.pot

.PHONY : po/CMakeFiles/kaltracker.ivoxavier.pot.dir/build

po/CMakeFiles/kaltracker.ivoxavier.pot.dir/clean:
	cd /home/ivo/ubtouchApps/kaltracker/build/all/app/po && $(CMAKE_COMMAND) -P CMakeFiles/kaltracker.ivoxavier.pot.dir/cmake_clean.cmake
.PHONY : po/CMakeFiles/kaltracker.ivoxavier.pot.dir/clean

po/CMakeFiles/kaltracker.ivoxavier.pot.dir/depend:
	cd /home/ivo/ubtouchApps/kaltracker/build/all/app && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/ivo/ubtouchApps/kaltracker /home/ivo/ubtouchApps/kaltracker/po /home/ivo/ubtouchApps/kaltracker/build/all/app /home/ivo/ubtouchApps/kaltracker/build/all/app/po /home/ivo/ubtouchApps/kaltracker/build/all/app/po/CMakeFiles/kaltracker.ivoxavier.pot.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : po/CMakeFiles/kaltracker.ivoxavier.pot.dir/depend

