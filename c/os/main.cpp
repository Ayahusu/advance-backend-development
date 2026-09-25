#include <iostream>
#include <sys/types.h>
#include <sys/sysctl.h>
#include <mach/mach.h>

int main()
{
    // 1. Get Total Physical RAM
    int64_t total_ram = 0;
    size_t size = sizeof(total_ram);

    // Multi-Management Information Base (MIB) query for hardware memory
    int mib[2] = {CTL_HW, HW_MEMSIZE};
    if (sysctl(mib, 2, &total_ram, &size, NULL, 0) != 0)
    {
        std::cerr << "Failed to get total RAM configuration." << std::endl;
        return 1;
    }

    // 2. Get Free/Available RAM
    mach_msg_type_number_t count = HOST_VM_INFO_COUNT;
    vm_statistics_data_t vm_stat;

    if (host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vm_stat, &count) != KERN_SUCCESS)
    {
        std::cerr << "Failed to get virtual memory statistics." << std::endl;
        return 1;
    }

    // macOS calculates memory in system pages. Standard page size is usually 4096 bytes.
    long long page_size = vm_kernel_page_size;
    long long free_ram = (long long)vm_stat.free_count * page_size;

    // Convert bytes to Megabytes (MB) for human readability
    std::cout << "--- macOS System Memory Info ---" << std::endl;
    std::cout << "Total RAM: " << (total_ram / (1024 * 1024)) << " MB" << std::endl;
    std::cout << "Free RAM:  " << (free_ram / (1024 * 1024)) << " MB" << std::endl;
    std::cout << "Used RAM:  " << ((total_ram - free_ram) / (1024 * 1024)) << " MB" << std::endl;

    return 0;
}
