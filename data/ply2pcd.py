import os
import glob
import re
import numpy as np
import open3d as o3d

def batch_convert_cloud_files(folder_path):
    # Match any .ply file in the folder
    pattern = os.path.join(folder_path, "*.ply")
    ply_files = glob.glob(pattern)
    
    if not ply_files:
        print(f"No matching '.ply' files found in: {folder_path}")
        return

    print(f"Found {len(ply_files)} files to convert.")

    # Transformation matrix from FRD (Forward, Right, Down) to FLU (Forward, Left, Up)
    frd_to_flu = np.array([
        [ 1.0,  0.0,  0.0,  0.0],
        [ 0.0, -1.0,  0.0,  0.0],
        [ 0.0,  0.0, -1.0,  0.0],
        [ 0.0,  0.0,  0.0,  1.0]
    ], dtype=np.float64)

    for ply_path in ply_files:
        filename = os.path.basename(ply_path)
        base_name, _ = os.path.splitext(filename)
        
        # Try to extract a number from the filename (e.g., cloud_0, scan123, etc.)
        match = re.search(r'(\d+)', base_name)
        if match:
            # If a number is found, use it as the new filename (e.g., "0.pcd")
            output_filename = f"{match.group(1)}.pcd"
        else:
            # Otherwise, keep the original name (e.g., "lidar_front.pcd")
            output_filename = f"{base_name}.pcd"
            
        output_path = os.path.join(folder_path, output_filename)
        
        print(f"Converting & Transforming: {filename} -> {output_filename}")
        
        # Read the point cloud
        pcd_data = o3d.io.read_point_cloud(ply_path)
        if not pcd_data.is_empty():
            # Apply FRD -> FLU coordinate frame transformation
            pcd_data.transform(frd_to_flu)
            
            # Save in compact binary PCD format
            o3d.io.write_point_cloud(output_path, pcd_data, write_ascii=False)
        else:
            print(f"[WARNING] Skipping empty or malformed file: {filename}")

    print("Batch conversion and transformation completed successfully!")

if __name__ == "__main__":
    target_folder = "./pointcloud" 
    batch_convert_cloud_files(target_folder)