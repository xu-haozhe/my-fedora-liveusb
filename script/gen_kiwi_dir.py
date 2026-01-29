from pathlib import Path
import shutil
import uuid
import json
import argparse
"""


"""


class HandleConfigScript:    
    dest_dir:Path
    @classmethod
    def run(cls,config_scripts:Path,root:Path,kiwi_dir:Path) -> Path:
        dirname=str(uuid.uuid4())
        dir=root/dirname
        cls.dest_dir=dir
        
        shutil.copytree(config_scripts,dir)
        
        config_sh=kiwi_dir/"config.sh"
        config:str=f"#!/bin/bash\n\nset -eu -o pipefail\n\n"
        config+="\n\n"

        config+=f"DIR=/{dirname}\n"
        config+='for script in "$DIR"/* ;do\n'
        config+='    "$script"\n'
        config+="done\n\n"

        config+=f"rm -rf /{dirname}\n"
        config+=f"echo /{dirname} 已清理"

        config_sh.touch(mode=0o755)
        config_sh.write_text(config)

        return dir
    @classmethod
    def add_file(cls,name:str,content:str|bytes):
        (cls.dest_dir/name).touch(mode=0o755)
        if isinstance(content,str):
            (cls.dest_dir/name).write_text(content)
        elif isinstance(content,bytes):
            (cls.dest_dir/name).write_bytes(content)
    pass

class HandleFlatpakApp:
    @classmethod
    def run(cls,json_file:Path,output:Path|None=None)->str:
        script:str=f"#!/bin/bash\n\nset -eu -o pipefail\n\n\n"

        with json_file.open("r") as f:
            data=json.load(f)

        repositories:dict=data["repositories"]
        for name,url in repositories.items():
            script+=f'flatpak remote-add --if-not-exists "{name}" "{url}"\n'
        script+="\n\n"

        all_apps:dict=data["apps"]
        for repo,apps in all_apps.items():
            apps:list
            for app in apps:
                script+=f'flatpak install --system -y --noninteractive "{repo}" "{app}"\n'
        script+='\n'

        if output:
            output.touch(mode=0o755)
            output.write_text(script)
            return ""
        return script
        pass

def main():
    parser=argparse.ArgumentParser()
    parser.add_argument("--input",type=Path,required=True)
    parser.add_argument("--output",type=Path,required=True)
    args=parser.parse_args()

    input_dir:Path=args.input.resolve()
    output_dir:Path=args.output.resolve()

    output_dir.mkdir(parents=True,exist_ok=True)

    shutil.copytree(input_dir/"kiwi",output_dir,dirs_exist_ok=True)
    shutil.copytree(input_dir/"root",output_dir/"root",dirs_exist_ok=True)


    HandleConfigScript.run(input_dir/"config_scripts",output_dir/"root",output_dir)
    HandleConfigScript.add_file("10-flatpak.sh",HandleFlatpakApp.run(input_dir/"flatpak_app.json"))

    pass

if __name__ == "__main__":
    main()