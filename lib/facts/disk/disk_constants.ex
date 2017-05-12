defmodule ExFacts.Disk.Constants do
  use ExFacts.Constants
  @moduledoc """
  Constants commonly used for filesystem identification.
  """

  const :sector_size, 512

  const :adfs_super_magic,            [0xadf5, "adfs"]
  const :affs_super_magic,            [0xADFF, "affs"]
  const :afs_super_magic,             [0x5346414F, "afs"]
  const :anon_inode_fs_super_magic,   [0x09041934, "anon-inode FS"]
  const :aufs_super_magic,            [0x61756673, "aufs"]
  const :befs_super_magic,            [0x42465331, "befs"]
  const :bdevfs_magic,                [0x62646576, "bdevfs"]
  const :bfs_magic,                   [0x1BADFACE, "bfs"]
  const :binfmtfs_magic,              [0x42494e4d, "binfmt_misc"]
  const :btrfs_super_magic,           [0x9123683E, "btrfs"]
  const :ceph_super_magic,            [0x00C36400, "ceph"]
  const :cgroup_super_magic,          [0x27e0eb, "cgroupfs"]
  const :cifs_magic_number,           [0xFF534D42, "cifs"]
  const :coda_super_magic,            [0x73757245, "coda"]
  const :coh_super_magic,             [0x012FF7B7, "coh"]
  const :cramfs_magic,                [0x28cd3d45, "cramfs"]
  const :debugfs_magic,               [0x64626720, "debugfs"]
  const :devfs_super_magic,           [0x1373, "devfs"]
  const :devpts_super_magic,          [0x1cd1, "devpts"]
  const :ecryptfs_super_magic,        [0xF15F, "ercyptfs"]
  const :efivarfs_magic,              [0xde5e81e4, ]
  const :efs_super_magic,             [0x00414A53, "efs"]
  const :ext_super_magic,             [0x137D, "ext"]
  const :ext2_old_super_magic,        [0xEF51, "ext2"]
  const :ext2_super_magic,            [0xEF53, "ext2/ext3"]
  const :ext3_super_magic,            [0xEF53, "ext2/ext3"]
  const :ext4_super_magic,            [0xEF53, "ext2/ext3"]
  const :fat_super_magic,             [0x4006, "fat"]
  const :fhgfs_super_magic,           [0x19830326, "fhgfs"]
  const :fuse_super_magic,            [0x65735546, "fuseblk"]
  const :fuseblk_super_magic,         [0x65735546, "fuseblk"]
  const :fusectl_super_magic,         [0x65735543, "fusectl"]
  const :futexfs_super_magic,         [0xBAD1DEA, "fusexfs"]
  const :gfs_super_magic,             [0x1161970, "gfs/gfs2"]
  const :gpfs_super_magic,            [0x47504653, "gpfs"]
  const :hfs_super_magic,             [0x4244, "hfs"]
  const :hostfs_super_magic,          [0x00c0ffee, ]
  const :hpfs_super_magic,            [0xF995E849, "hpfs"]
  const :hugetlbfs_magic,             [0x958458f6, "hugetlbfs"]
  const :inotifyfs_super_magic,       [0x2BAD1DEA, "inotifyfs"]
  const :isofs_super_magic,           [0x9660, "isofs"]
  const :isofs_r_win_super_magic,     [0x4004, "isofs"]
  const :isofs_win_super_magic,       [0x4000, "isofs"]
  const :jffs_super_magic,            [0x07C0, "jffs"]
  const :jffs2_super_magic,           [0x72b6, "jffs2"]
  const :jfs_super_magic,             [0x3153464a, "jfs"]
  const :kafs_super_magic,            [0x6B414653, "k-afs"]
  const :lustre_super_magic,          [0x0BD00BD0, "lustre"]
  const :minix_super_magic,           [0x137F, "minix"] # orig. minix
  const :minix_super_magic2,          [0x138F, "minix (30 char)"] # 30 char minix
  const :minix2_super_magic,          [0x2468, "minix v2"] # minix V2
  const :minix2_super_magic2,         [0x2478, "minix v2 (30 char)"] # minix V2, 30 char names
  const :minix3_super_magic,          [0x4d5a, "minix3"] # minix V3 fs, 60 char names
  const :mqueue_magic,                [0x19800202, "mqueue"]
  const :msdos_super_magic,           [0x4d44, "msdos"]
  const :mtd_inode_fs_super_magic,    [0x11307854, ]
  const :ncp_super_magic,             [0x564c, "novell"]
  const :nfs_super_magic,             [0x6969, "nfs"]
  const :nfsd_super_magic,            [0x6E667364, "nfsd"]
  const :nilfs_super_magic,           [0x3434, "nilfs"]
  const :ntfs_sb_magic,               [0x5346544e, "ntfs"]
  const :ocfs2_super_magic,           [0x7461636f, "ocfs2"]
  const :openprom_super_magic,        [0x9fa1, "openprom"]
  const :panfs_super_magic,           [0xAAD7AAEA, "panfs"]
  const :pipefs_magic,                [0x50495045, "pipefs"]
  const :proc_super_magic,            [0x9fa0, "proc"]
  const :pstorefs_magic,              [0x6165676C, "pstorefs"]
  const :qnx4_super_magic,            [0x002f, "qnx4"]
  const :qnx6_super_magic,            [0x68191122, "qnx6"]
  const :ramfs_magic,                 [0x858458f6, "ramfs"]
  const :reiserfs_super_magic,        [0x52654973, "reiserfs"]
  const :romfs_magic,                 [0x7275, "romfs"]
  const :rpc_pipefs_super_magic,      [0x67596969, "rpc_pipefs"]
  const :securityfs_super_magic,      [0x73636673, "securityfs"]
  const :selinux_magic,               [0xf97cff8c, "selinux"]
  const :smack_magic,                 [0x43415d53, ]
  const :smb_super_magic,             [0x517B, "smb"]
  const :sockfs_magic,                [0x534F434B, "sockfs"]
  const :squashfs_magic,              [0x73717368, "squashfs"]
  const :sysfs_magic,                 [0x62656572, "sysfs"]
  const :sysv2_super_magic,           [0x012FF7B6, "sysv2"]
  const :sysv4_super_magic,           [0x012FF7B5, "sysv4"]
  const :tmpfs_magic,                 [0x01021994, "tmpfs"]
  const :udf_super_magic,             [0x15013346, "udf"]
  const :ufs_byteswapped_super_magic, [0x54190100, "ufs"]
  const :ufs_magic,                   [0x00011954, "ufs"]
  const :usbdevice_super_magic,       [0x9fa2, "usbdevfs"]
  const :v9fs_magic,                  [0x01021997, "v9fs"]
  const :vmhgfs_super_magic,          [0xBACBACBC, "vmhgfs"]
  const :vxfs_super_magic,            [0xa501FCF5, "vxfs"]
  const :vzfs_super_magic,            [0x565A4653, "vzfs"]
  const :xenfs_super_magic,           [0xabba1974, "xenfs"]
  const :xenix_super_magic,           [0x012FF7B4, "xenix"]
  const :xfs_super_magic,             [0x58465342, "xfs"]
  const :xiafs_super_magic,           [0x012FD16D, "xia"]
  const :zfs_super_magic,             [0x2FC12FC1, "zfs"]
end
