<?php
abstract class CategoryBaseModel extends BaseModel
{
	public $levelFieldName = 'Level';
	public $parentFieldName = 'Parent';
	public $aliasFieldName = 'Alias';
	public $childrenFieldName = 'Children';
	public $itemTableName = '';
	public $itemTableNumFieldName = 'Nums';
	public $itemTableCategoryFieldName = 'CategoryID';
	public $oldCategoryID = 0;
	public function parseData(&$data)
	{
		if(isEmpty($data['Name']))
		{
			return '分类名称不能为空';
		}
		if(0 == $data[$this->parentFieldName])
		{
			$data[$this->levelFieldName] = 0;
		}
		else
		{
			$info = $this->getByPk($data[$this->parentFieldName]);
			$data[$this->levelFieldName] = $info[$this->levelFieldName] + 1;
		}
		if(isset($data[$this->pk]))
		{
			$info = $this->getByPk($data[$this->pk]);
			$this->oldCategoryID = $info[$this->parentFieldName];
		}
	}
	/**
	 * 创建分类，成功返回分类ID，失败返回错误信息
	 * @param $data array 数据
	 * @return mixed
	 */
	public function create($data)
	{
		$result = $this->parseData($data);
		if(null !== $result)
		{
			return $result;
		}
		$result = $this->add($data,Db::RETURN_INSERT_ID);
		if($result > 0)
		{
			return $result;
		}
		else
		{
			return '创建失败';
		}
	}
	/**
	 * 修改分类
	 * @param $data array 数据
	 * @return mixed
	 */
	public function update($data)
	{
		$result = $this->parseData($data);
		if(null !== $result)
		{
			return $result;
		}
		$result = $this->where(array($this->pk=>$data[$this->pk]))->edit($data,Db::RETURN_INSERT_ID);
		if($result > 0)
		{
			return $result;
		}
		else
		{
			return '创建失败';
		}
	}
	/**
	 * 获取关联列表
	 * @param unknown $id
	 */
	public function getAssocList()
	{
		// 查询出所有分类记录
		$arr1 = $this->selectList();
		$arr2 = array();
		// 处理成ID为键名的数组
		foreach($arr1 as $val)
		{
			$arr2[$val[$this->pk]] = $val;
		}
		// 节省内存
		unset($arr1,$val);
		// 结果数组
		$result = array();
		// 循环处理关联列表
		foreach($arr2 as $item)
		{
			if(isset($arr2[$item[$this->parentFieldName]]))
			{
				$arr2[$item[$this->parentFieldName]][$this->childrenFieldName][] = &$arr2[$item[$this->pk]];
			}
			else
			{
				$result[] = &$arr2[$item[$this->pk]];
			}
		}
		return $result;
	}
	/**
	 * 获取下属所有级的子分类的ID
	 * @param number $id
	 * @param string $first
	 * @return multitype:
	 */
	public function getChildsIds($id=0,$first=true)
	{
		if(is_array($id))
		{
			$ids = array();
			// 多个分类
			foreach($id as $value)
			{
				$ids = array_merge($ids,$this->getChildsIds($value,false));
			}
		}
		else
		{
			$ids = array($id);
			$children = $this->field($this->pk)->where(array($this->parentFieldName=>$id))->select();
			foreach($children as &$value)
			{
				if($id === $value[$this->pk])
				{
					continue;
				}
				$ids = array_merge($ids,$this->getChildsIds($value[$this->pk],false));
			}
		}
		return $first?array_unique($ids):$ids;
	}
	/**
	 * 获取一级子分类的ID们
	 * @param number $parent
	 */
	public function getChildId($parent = 0)
	{
		$ids = array();
		$children = $this->field($this->pk)->where(array($this->parentFieldName=>$parent))->select();
		foreach($children as &$value)
		{
			$ids[] = $value[$this->pk];
		}
		return $ids;
	}
	/**
	 * 检测别名是否存在。存在返回true，不存在或别名为空返回false
	 * @param unknown $alias
	 * @return boolean
	 */
	public function aliasExists($alias,$currID = null)
	{
		if(null !== $currID)
		{
			$this->where(array($this->pk=>array('<>',$currID)));
		}
		return '' !== $alias && $this->where(array($this->aliasFieldName=>$alias))->count() > 0;
	}
	/**
	 * 获取父级所有级的ID
	 * @param number $id
	 * @param string $first
	 * @return multitype:
	 */
	public function getParentIds($id = 0,$first = true)
	{
		if(is_array($id))
		{
			$ids = array();
			// 多个分类
			foreach($id as $value)
			{
				$ids = array_merge($ids,$this->getParentIds($value,false));
			}
		}
		else
		{
			$ids = array($id);
			$parent = $this->field($this->parentFieldName)->where(array($this->pk=>$id))->select(true);
			if(isset($parent[$this->parentFieldName]))
			{
				$ids = array_merge($ids,$this->getParentIds($parent[$this->parentFieldName],false));
			}
		}
		return $first?array_unique($ids):$ids;
	}
	/**
	 * 添加站点数
	 * @param type $categoryID
	 * @param type $num
	 */
	public function addArticle($categoryID,$num = 1)
	{
		$ids = $this->getParentIds($categoryID);
		return $this->where(array($this->pk=>array('in',$ids)))->inc(array('Articles'=>$num));
	}
	/**
	 * 减少站点数
	 * @param type $categoryID
	 * @param type $num
	 */
	public function deleteArticle($categoryID,$num = 1)
	{
		$ids = $this->getParentIds($categoryID);
		return $this->where(array($this->pk=>array('in',$ids)))->dec(array('Articles'=>$num));
	}
	/**
	 * 更新父级
	 * @param type $id
	 */
	public function updateParent($id,$first = true)
	{
		$this->updateItemNumsByChildren($id);
		$parentID = $this->field($this->parentFieldName)->where(array($this->pk=>$id))->selectValue();
		if($parentID > 0)
		{
			$this->updateParent($parentID,false);
		}
		if($first && $this->oldCategoryID != $id && $this->oldCategoryID > 0)
		{
			$this->updateParent($this->oldCategoryID,false);
		}
	}
	/*
	 * 根据子节点更新站点数
	 */
	public function updateItemNumsByChildren($id)
	{
		if(empty($this->itemTableName))
		{
			return;
		}
		$tableName = $this->tableName();
		$ItemTableName = $this->tableName($this->itemTableName);
		return $this->getDb()->execute(
<<<SQL
UPDATE {$tableName}
SET {$this->itemTableNumFieldName} = COALESCE (
	(
		SELECT
			nums
		FROM
			(
				SELECT
					sum({$this->itemTableNumFieldName}) AS nums
				FROM
					{$tableName}
				WHERE
					{$this->parentFieldName} = {$id}
			) AS t
	),
	0
) + (select count(*) from {$ItemTableName} where {$this->itemTableCategoryFieldName} = {$id})
where {$this->pk} = {$id}
SQL
);
	}
	/**
	 * 更新子级
	 * @param type $id
	 */
	public function updateChildren($id)
	{
		$data = $this->getInfo($id);
		$level = $data[$this->levelFieldName] + 1;
		$ids = $this->getChildId($id);
		if(!empty($ids))
		{
			$this->where(array($this->pk=>array('in',$ids)))->edit(array($this->levelFieldName=>$level));
			foreach($ids as $id)
			{
				$this->updateChildren($id);
			}
		}
	}
	/**
	 * 刷新文章数量
	 */
	public function refreshArticles()
	{
		$data = $this->order(array($this->levelFieldName=>'desc'))
					 ->field(array($this->pk))
					 ->select();
		$data = array_column($data, $this->pk);
		$result = true;
		foreach($data as $id)
		{
			$result = $result && $this->updateItemNumsByChildren($id);
			if(!$result)
			{
				break;
			}
		}
		return $result;
	}
	
	/**
	 * 获取一条记录
	 * @param type $aliasOrID
	 * @return type
	 */
	public function getInfo($aliasOrID,$data = array())
	{
		// 先根据Alias获取
		$data = $this->parseSelect($data)->where(array($this->tableName() . '.Alias' => $aliasOrID))->select(true);
		if(!isset($data[$this->pk]))
		{
			// Alias不存在再根据ID获取
			$data = $this->parseSelect($data)->where(array($this->tableName() . '.ID' => $aliasOrID))->select(true);
		}
		$this->parseDataAfter($data);
		return $data;
	}
}